//
//  DayForcast.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/16/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import Foundation

struct DayForcast: Codable {
    var weatherId: Int = 0
    var maxTemp: Int = 0
    var minTemp: Int = 0
    var description: String = ""
    var dayOfTheWeek: String = ""
    var pressure: Int = 0
    var humidity: Int = 0
    var windDirection: Direction = .N
    var windSpeed: Int = 0
    var clouds: Float = 0.0
    var windAngle: Float = 0.0

    private enum CodingKeys: String, CodingKey {
        case weatherId = "id"
        case forcast = "main"
        case temp_max = "max"
        case temp_min = "min"
    }

    private enum RootKeys: String, CodingKey {
        case temp
        case weather
        case pressure
        case humidity
        case speed
        case deg
        case clouds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weather = try weatherContainer.nestedContainer(keyedBy: CodingKeys.self)
        weatherId = try weather.decode(Int.self, forKey: .weatherId)
        description = try weather.decode(String.self, forKey: .forcast)
        let temp = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .temp)
        maxTemp = try temp.decode(Float.self, forKey: .temp_max).roundedToInt()
        minTemp = try temp.decode(Float.self, forKey: .temp_min).roundedToInt()
        pressure = try container.decode(Float.self, forKey: .pressure).roundedToInt()
        humidity = try container.decode(Float.self, forKey: .humidity).roundedToInt()
        windSpeed = try container.decode(Float.self, forKey: .speed).roundedToInt()
        windAngle = try container.decode(Float.self, forKey: .deg)
        windDirection = Direction.from(angle: windAngle)
        clouds = try container.decode(Float.self, forKey: .clouds) / 100.0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKeys.self)
        var weatherContainer = container.nestedUnkeyedContainer(forKey: .weather)
        var weather = weatherContainer.nestedContainer(keyedBy: CodingKeys.self)
        try weather.encode(weatherId, forKey: .weatherId)
        try weather.encode(description, forKey: .forcast)
        var temp = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .temp)
        try temp.encode(maxTemp, forKey: .temp_max)
        try temp.encode(minTemp, forKey: .temp_min)
        try container.encode(Float(pressure), forKey: .pressure)
        try container.encode(Float(humidity), forKey: .humidity)
        try container.encode(Float(windSpeed), forKey: .speed)
        try container.encode(windAngle, forKey: .deg)
        try container.encode(clouds * 100.0, forKey: .clouds)
    }
}
