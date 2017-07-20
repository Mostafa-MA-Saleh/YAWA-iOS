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
    let pressure: Int
    let humidity: Int
    let wind_direction: String
    let wind_speed: Int
    let clouds: Float
    
    init(weatherId: Int, date: String, forcast: String, temp_max: Int, temp_min: Int, pressure: Int, humidity: Int, wind_direction: Float, wind_speed: Int, clouds: Float) {
        self.weatherId = weatherId
        self.date = date
        self.forcast = forcast
        self.temp_max = temp_max
        self.temp_min = temp_min
        self.pressure = pressure
        self.humidity = humidity
        self.wind_direction = Utils.getDirection(angle: wind_direction)
        self.wind_speed = wind_speed
        self.clouds = clouds / 100
    }
    
}
