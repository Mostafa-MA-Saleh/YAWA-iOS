//
//  DetailsViewConroller.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/20/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit
import CircleProgressBar

class DetailsViewController: UIViewController {
    
    //MARK: Properties
    var forcast: DayForcast!
    @IBOutlet weak var forcastImageView: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var forcastLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var cloudsProgressBar: CircleProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = forcast.date
        tempMaxLabel.text = "\(forcast.temp_max)°"
        tempMinLabel.text = "\(forcast.temp_min)°"
        forcastLabel.text = forcast.forcast
        pressureLabel.text = "\(forcast.pressure) hPa"
        humidityLabel.text = "\(forcast.humidity)%"
        windDirectionLabel.text = forcast.wind_direction
        windSpeedLabel.text = "\(forcast.wind_speed) km/h"
        cloudsProgressBar.setProgress(CGFloat(forcast.clouds), animated: true)
        forcastImageView.image = Utils.getArtResourceForWeatherCondition(weatherId: forcast.weatherId)
    }
    
}
