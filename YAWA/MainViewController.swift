//
//  ViewController.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/16/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import Alamofire
import CodableAlamofire
import UIKit

class MainViewController: UIViewController, UITableViewDataSource {
    // MARK: Properties

    var url: String = ""
    var forcasts = [DayForcast]()

    // MARK: Outlets

    @IBOutlet var forcastTableView: UITableView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var forcastLabel: UILabel!
    @IBOutlet var forcastImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        forcastTableView.dataSource = self
        setupPullToRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let newUrl = buildUrlFromPrefrences()
        if url != newUrl {
            url = newUrl
            refreshData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsViewController = segue.destination as? DetailsViewController {
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
    }

    func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh!")
        refreshControl.addTarget(self, action: #selector(MainViewController.refreshData), for: .valueChanged)
        forcastTableView.refreshControl = refreshControl
    }

    @objc func refreshData() {
        forcastTableView.refreshControl?.beginRefreshing()
        Alamofire.request(url, method: .get).validate().responseDecodableObject(keyPath: "list") { [weak self] (response: DataResponse<[DayForcast]>) in
            guard let self = self else { return }
            switch response.result {
            case let .failure(error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case let .success(forcasts):
                self.loadData(forcasts)
            }
            self.forcastTableView.refreshControl?.endRefreshing()
        }
    }

    func buildUrlFromPrefrences() -> String {
        let preferences = UserDefaults.standard
        let units: String = preferences.string(forKey: Constants.KEY_UNITS) ?? Constants.DEFAULT_UNITS
        let cityId = preferences.string(forKey: Constants.KEY_CITY_ID)?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? Constants.DEFAULT_CITY_ID
        return String(format: Constants.URL, arguments: [cityId, units])
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DayForcastTableViewCell else {
            fatalError("The dequeued cell is not an instance of DayForcastTabelViewCell.")
        }
        let forcast = forcasts[indexPath.row]
        cell.dateLabel.text = forcast.dayOfTheWeek
        cell.forcastLabel.text = forcast.description
        cell.maxTempLabel.text = "\(forcast.maxTemp)°"
        cell.minTempLabel.text = "\(forcast.minTemp)°"
        cell.focastImageView.image = Utils.getIconResourceForWeatherCondition(weatherId: forcast.weatherId)
        return cell
    }

    // MARK: Private Functions

    private func loadData(_ forcasts: [DayForcast]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        var moddedForcasts: [DayForcast] = []
        for (index, forcast) in forcasts.enumerated() {
            let weekday = Calendar.current.date(byAdding: .weekday, value: index, to: Date())!
            var dayForcast = forcast
            dayForcast.dayOfTheWeek = dateFormatter.string(from: weekday)
            moddedForcasts.append(dayForcast)
        }
        setupHeaderView(moddedForcasts.remove(at: 0))
        let updating = !self.forcasts.isEmpty
        self.forcasts.removeAll()
        self.forcasts.append(contentsOf: moddedForcasts)
        let indexPaths = moddedForcasts.enumerated().map { IndexPath(row: $0.offset, section: 0) }
        if updating {
            forcastTableView.reloadRows(at: indexPaths, with: .automatic)
        } else {
            forcastTableView.insertRows(at: indexPaths, with: .left)
        }
    }

    private func setupHeaderView(_ dayForcast: DayForcast) {
        let formatter = DateFormatter()
        formatter.dateFormat = "'Today,' MMMM dd"
        dateLabel.text = formatter.string(from: Date())
        maxTempLabel.text = "\(dayForcast.maxTemp)°"
        minTempLabel.text = "\(dayForcast.minTemp)°"
        forcastLabel.text = dayForcast.description
        forcastImageView.image = Utils.getArtResourceForWeatherCondition(weatherId: dayForcast.weatherId)
    }
}
