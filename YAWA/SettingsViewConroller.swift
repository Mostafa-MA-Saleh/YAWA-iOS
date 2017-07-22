//
//  TestViewConroller.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/21/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit
import CountryPicker
import SwiftyJSON

class SettingsViewController: UIViewController {
    
    //MARK: Properties
    let countryPicker = CountryPicker()
    let cityPicker    = CityPicker()
    let preferences = UserDefaults.standard
    
    //MARK: Outlets
    @IBOutlet weak var unitsSwitch: UISwitch!
    @IBOutlet weak var selectedLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let preferedUnits = preferences.string(forKey: Constants.KEY_UNITS) {
            unitsSwitch.isOn = preferedUnits == Constants.UNITS_IMPERIAL
        }
        selectedLocationLabel.text = (preferences.string(forKey: Constants.KEY_CITY_ID) ?? Constants.DEFAULT_CITY_ID) + " >"
    }
    
    func didSelectCountry() {
        if cityPicker.populate(cities: getCities(in: countryPicker.selectedCountryName)) {
            Utils.presentPicker(cityPicker, presenter: self, onDone: {_ in
                self.didSelectCity()
            })
        } else {
            let alert = UIAlertController(title: "Sorry", message: "Sorry, but this country is not supported, please choose another country!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                self.showCountryPicker()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func didSelectCity() {
        let currentCityId = "\(cityPicker.selectedCity),\(countryPicker.selectedCountryCode!)"
        selectedLocationLabel.text = currentCityId + " >"
        preferences.set(currentCityId, forKey: Constants.KEY_CITY_ID)
        preferences.synchronize()
    }
    
    func getCities(in country: String) -> [JSON] {
        let path = Bundle.main.path(forResource: "countriesToCities", ofType: "json")
        let jsonFile = NSData(contentsOfFile: path!)
        let json = JSON(jsonFile!)
        return json[country].arrayValue
    }
    
    func showCountryPicker() {
        Utils.presentPicker(countryPicker, presenter: self, onDone: {_ in
            self.didSelectCountry()
        })
    }
    
    //MARK: Actions
    @IBAction func unitsSwithValueChanged(_ sender: UISwitch) {
        let units = sender.isOn ? Constants.UNITS_IMPERIAL : Constants.UNITS_METRIC
        preferences.set(units, forKey: Constants.KEY_UNITS)
        preferences.synchronize()
    }
    
    @IBAction func LocationClick(_ sender: UITapGestureRecognizer) {
        showCountryPicker()
    }
}
