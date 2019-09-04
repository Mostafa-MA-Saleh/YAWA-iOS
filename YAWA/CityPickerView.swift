//
//  CityPickerView.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/21/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import SwiftyJSON
import UIKit

class CityPicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    var cities = [JSON]()
    var selectedCity = ""

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setUp() {
        super.dataSource = self
        super.delegate = self
    }

    func populate(cities: [JSON]) -> Bool {
        self.cities = cities
        if cities.count == 0 {
            return false
        }
        selectedCity = cities[0].stringValue
        reloadAllComponents()
        return true
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row].stringValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cities[row].stringValue
    }
}
