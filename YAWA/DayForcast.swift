//
//  DayForcast.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/16/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import Foundation

struct DayForcast: Decodable {
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
        windDirection = Direction.from(angle: try container.decode(Float.self, forKey: .deg))
        clouds = try container.decode(Float.self, forKey: .clouds) / 100.0
    }
}
