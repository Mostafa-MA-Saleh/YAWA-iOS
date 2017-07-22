//
//  Utils.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/16/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit

class Utils {
    
    private static let days = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Firday"]
    private static let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]

    static func getIconResourceForWeatherCondition(weatherId: Int) -> UIImage {
        // Based on weather code data found at:
        // http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
        if weatherId >= 200 && weatherId <= 232 {
            return #imageLiteral(resourceName: "ic_storm")
        } else if weatherId >= 300 && weatherId <= 321 {
            return #imageLiteral(resourceName: "ic_light_rain")
        } else if weatherId >= 500 && weatherId <= 504 {
            return #imageLiteral(resourceName: "ic_rain")
        } else if weatherId == 511 {
            return #imageLiteral(resourceName: "ic_snow")
        } else if weatherId >= 520 && weatherId <= 531 {
            return #imageLiteral(resourceName: "ic_rain")
        } else if weatherId >= 600 && weatherId <= 622 {
            return #imageLiteral(resourceName: "ic_snow")
        } else if weatherId >= 701 && weatherId <= 761 {
            return #imageLiteral(resourceName: "ic_fog")
        } else if weatherId == 761 || weatherId == 781 {
            return #imageLiteral(resourceName: "ic_storm")
        } else if weatherId == 800 {
            return #imageLiteral(resourceName: "ic_clear")
        } else if weatherId == 801 {
            return #imageLiteral(resourceName: "ic_light_clouds")
        } else if weatherId >= 802 && weatherId <= 804 {
            return #imageLiteral(resourceName: "ic_cloudy")
        }
        return #imageLiteral(resourceName: "ic_clear")
    }
    
    static func getArtResourceForWeatherCondition(weatherId: Int) -> UIImage {
        // Based on weather code data found at:
        // http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
        if weatherId >= 200 && weatherId <= 232 {
            return #imageLiteral(resourceName: "art_storm")
        } else if weatherId >= 300 && weatherId <= 321 {
            return #imageLiteral(resourceName: "art_light_rain")
        } else if weatherId >= 500 && weatherId <= 504 {
            return #imageLiteral(resourceName: "art_rain")
        } else if weatherId == 511 {
            return #imageLiteral(resourceName: "art_snow")
        } else if weatherId >= 520 && weatherId <= 531 {
            return #imageLiteral(resourceName: "art_rain")
        } else if weatherId >= 600 && weatherId <= 622 {
            return #imageLiteral(resourceName: "art_snow")
        } else if weatherId >= 701 && weatherId <= 761 {
            return #imageLiteral(resourceName: "art_fog")
        } else if weatherId == 761 || weatherId == 781 {
            return #imageLiteral(resourceName: "art_storm")
        } else if weatherId == 800 {
            return #imageLiteral(resourceName: "art_clear")
        } else if weatherId == 801 {
            return #imageLiteral(resourceName: "art_light_clouds")
        } else if weatherId >= 802 && weatherId <= 804 {
            return #imageLiteral(resourceName: "art_clouds")
        }
        return #imageLiteral(resourceName: "art_clear")
    }
    
    static func getRandomNumber(from: Int, upTo: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upTo - from))) + from
    }
    
    static func getDayOfWeek(number: Int) -> String {
        let dayIndex = (number % 7) - 1
        if dayIndex < 0 {
            return days[6]
        } else {
            return days[dayIndex]
        }
    }
    
    static func getDirection(angle: Float) -> String {
        let val = (Int((angle / 22.5) + 0.5));
        return directions[val % 16];
    }
    
    static func presentPicker(_ picker: UIPickerView, presenter: UIViewController, onDone: @escaping (UIAlertAction) -> Void) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 220)
        vc.view.addSubview(picker)
        picker.sizeThatFits(vc.preferredContentSize)
        let pickerAlert = UIAlertController(title: "Choose a City", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        pickerAlert.setValue(vc, forKey: "contentViewController")
        pickerAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: onDone))
        pickerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        presenter.present(pickerAlert, animated: true)
    }
}
