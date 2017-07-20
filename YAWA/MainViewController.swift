//
//  ViewController.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/16/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDataSource {
    
    //MARK: Properties
    let refreshConrol = UIRefreshControl()
    var url: String = ""
    var alreadyRegistered = false
    var forcasts = [DayForcast]()
    @IBOutlet weak var forcastTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var forcastLabel: UILabel!
    @IBOutlet weak var forcastImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forcastTableView.dataSource = self
        setupPullToRefresh()
        registerSettingsBundle()
        updateUrlFromDefaults()
        refreshData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsViewController = segue.destination as? DetailsViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedCell = sender as? DayForcastTableViewCell else {
            fatalError("Unexpected sender: \(sender ?? "nil")")
        }
        
        guard let indexPath = forcastTableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedDay = forcasts[indexPath.row]
        detailsViewController.forcast = selectedDay
        
        forcastTableView.deselectRow(at: indexPath, animated: true)
    }
   
    func setupPullToRefresh() {
        refreshConrol.attributedTitle = NSAttributedString(string: "Pull To Refresh!")
        refreshConrol.addTarget(self, action: #selector(MainViewController.refreshData), for: .valueChanged)
        forcastTableView.refreshControl = refreshConrol
    }
    
    func refreshData() {
        refreshConrol.beginRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .success(_):
                self.loadData(response)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.refreshConrol.endRefreshing()
        }
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func updateUrlFromDefaults(){
        let defaults = UserDefaults.standard
        var cityId = "361058"
        var units: String = "metric"
        if let defaultId = defaults.string(forKey: "city_id_preference") {
            if !defaultId.isEmpty {
                cityId = defaultId
            }
        }
        if defaults.bool(forKey: "imperial_preference") {
            units = "imperial"
        }
        url = "http://api.openweathermap.org/data/2.5/forecast/daily?id=\(cityId)&units=\(units)&cnt=16&APPID=026ee82032707259db948706d2c48df2"
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DayForcastTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DayForcastTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DayForcastTabelViewCell.")
        }
        let forcast = forcasts[indexPath.row]
        cell.dateLabel.text = forcast.date
        cell.forcastLabel.text = forcast.forcast
        cell.maxTempLabel.text = "\(forcast.temp_max)°"
        cell.minTempLabel.text = "\(forcast.temp_min)°"
        cell.focastImageView.image = Utils.getIconResourceForWeatherCondition(weatherId: forcast.weatherId)
        return cell
    }
    
    func add(_ newElement: DayForcast) {
        let newIndexPath = IndexPath(row: forcasts.count, section: 0)
        forcasts.append(newElement)
        forcastTableView.insertRows(at: [newIndexPath], with: .left)
    }
    
    func update(_ newElement: DayForcast, position: Int) {
        let newIndexPath = IndexPath(row: position, section: 0)
        forcasts[position] = newElement
        forcastTableView.reloadRows(at: [newIndexPath], with: .automatic)
    }
    
    
    //MARK: Private Functions
    private func loadData(_ response: DataResponse<Any>) {
        let json = JSON(response.result.value!)
        let list = json["list"]
        for (index,subJson):(String, JSON) in list {
            let weekday = Calendar.current.component(.weekday, from: Date()) + Int(index)! + 1
            let weatherId = subJson["weather"][0]["id"].intValue
            let forcast = subJson["weather"][0]["main"].stringValue
            let tempMax = subJson["temp"]["max"].intValue
            let tempMin = subJson["temp"]["min"].intValue
            let pressure = subJson["pressure"].intValue
            let humidity = subJson["humidity"].intValue
            let windSpeed = subJson["speed"].intValue
            let windDirection = subJson["deg"].floatValue
            let clouds = subJson["clouds"].floatValue
            let dayForcast = DayForcast(weatherId: weatherId, date: Utils.getDayOfWeek(number: weekday), forcast: forcast, temp_max: tempMax, temp_min: tempMin, pressure: pressure, humidity: humidity, wind_direction: windDirection, wind_speed: windSpeed, clouds: clouds)
            if index == "0" {
                self.setupHeaderView(dayForcast)
            } else {
                if forcasts.count < 15 {
                    self.add(dayForcast)
                } else {
                    self.update(dayForcast, position: Int(index)! - 1)
                }
            }
        }
    }
    
    private func setupHeaderView(_ dayForcast: DayForcast) {
        let formatter  = DateFormatter()
        formatter.dateFormat = "'Today,' MMMM dd"
        dateLabel.text = formatter.string(from: Date())
        maxTempLabel.text = "\(dayForcast.temp_max)°"
        minTempLabel.text = "\(dayForcast.temp_min)°"
        forcastLabel.text = dayForcast.forcast
        forcastImageView.image = Utils.getArtResourceForWeatherCondition(weatherId: dayForcast.weatherId)
    }

}

