//
//  Constants.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/22/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

class Constants {
    
    //Keys for UserDefaults
    static let KEY_CITY_ID     = "City Id"
    static let KEY_UNITS       = "Units"
    
    //Default Values
    static let DEFAULT_CITY_ID = "Alexandria,EG"
    static let DEFAULT_UNITS   = UNITS_METRIC
    
    //Units
    static let UNITS_METRIC    = "metric"
    static let UNITS_IMPERIAL  = "imperial"
    
    static let API_KEY         = "026ee82032707259db948706d2c48df2"
    static let URL             = "http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&units=%@&cnt=16&APPID=\(API_KEY)"
    
    //Seques
    static let SEGUE_SETTINGS = "settingsSegue"
    
    //Quick Actions
    static let ACTION_SETTINGS = "Quick_Action.Settings"
    
}
