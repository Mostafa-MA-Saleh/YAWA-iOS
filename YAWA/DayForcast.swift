//
//  DayForcast.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/16/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import Foundation

class DayForcast {
    
    let weatherId: Int
    let temp_max: Int
    let temp_min: Int
    let forcast: String
    let date: String
    
    init(weatherId: Int, date: String, forcast: String, temp_max: Int, temp_min: Int) {
        self.weatherId = weatherId
        self.date = date
        self.forcast = forcast
        self.temp_max = temp_max
        self.temp_min = temp_min
    }
    
}
