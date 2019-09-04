//
//  DetailsViewConroller.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/20/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit
import CircleProgressBar
import CountryPicker

class DetailsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var forcastImageView: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var forcastLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var cloudsProgressBar: CircleProgressBar!
    
    //MARK: Properties
    var forcast: DayForcast!
    var windspeedUnit: String {
        get {
            let preferences = UserDefaults.standard
            let units = preferences.string(forKey: Constants.KEY_UNITS) ?? Constants.DEFAULT_UNITS
            return units == Constants.UNITS_METRIC ? "km/h" : "mph"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = forcast.dayOfTheWeek
        tempMaxLabel.text = "\(forcast.maxTemp)°"
        tempMinLabel.text = "\(forcast.minTemp)°"
        forcastLabel.text = forcast.description
        pressureLabel.text = "\(forcast.pressure) hPa"
        humidityLabel.text = "\(forcast.humidity)%"
        windDirectionLabel.text = forcast.windDirection.rawValue
        windSpeedLabel.text = "\(forcast.windSpeed) \(windspeedUnit)"
        cloudsProgressBar.setProgress(CGFloat(forcast.clouds), animated: true)
        forcastImageView.image = Utils.getArtResourceForWeatherCondition(weatherId: forcast.weatherId)
    }
    
}
