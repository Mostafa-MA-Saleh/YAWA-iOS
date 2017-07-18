//
//  ViewController.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/16/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource {
    
    //MARK: Properties
    let url = "http://api.openweathermap.org/data/2.5/forecast/daily?id=361058&units=metric&cnt=16&APPID=026ee82032707259db948706d2c48df2"
    var forcasts = [DayForcast]()
    let progressHUD = ProgressHUD(text: "Please wait...")
    @IBOutlet weak var forcastTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var forcastLabel: UILabel!
    @IBOutlet weak var forcastImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(progressHUD)
        forcastTableView.dataSource = self
        requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Private Functions
    private func loadData(_ response: DataResponse<Any>) {
        guard let json = response.result.value as? [String: Any] else {
            fatalError("Error: \(response.result.error?.localizedDescription ?? "Error")")
        }
        guard let list = json["list"] as? NSArray else {
            fatalError("not a list")
        }
        for index in 0..<list.count{
            guard let day = list[index] as? [String: Any] else {
                fatalError("malformed json")
            }
            guard let temp = day["temp"] as? [String: Any] else {
                fatalError("malformed json")
            }
            guard let weatherList = day["weather"] as? NSArray else {
                fatalError("malformed json")
            }
            guard let weather = weatherList[0] as? [String: Any] else {
                fatalError("malformed json")
            }
            let weekday = Calendar.current.component(.weekday, from: Date()) + index + 1
            let dayForcast = DayForcast(weatherId: weather["id"]! as! Int, date: Utils.getDayOfWeek(number: weekday), forcast: weather["main"]! as! String, temp_max: temp["max"]! as! Int, temp_min: temp["min"]! as! Int)
            if index == 0 {
                self.setupHeaderView(dayForcast)
            } else {
                self.add(dayForcast)
            }
        }
    }
    private func requestData() {
        progressHUD.show()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    self.requestData()
                }))
                self.present(alert, animated: true, completion: nil)
            case .success(_):
                self.loadData(response)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.progressHUD.hide()
        }
    }
    private func setupHeaderView(_ dayForcast: DayForcast) {
        let formatter  = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        dateLabel.text = "Today, \(formatter.string(from: Date()))"
        maxTempLabel.text = "\(dayForcast.temp_max)°"
        minTempLabel.text = "\(dayForcast.temp_min)°"
        forcastLabel.text = dayForcast.forcast
        forcastImageView.image = Utils.getArtResourceForWeatherCondition(weatherId: dayForcast.weatherId)
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
        forcastTableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}

