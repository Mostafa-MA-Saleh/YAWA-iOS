//
//  CountrySelectorViewController.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/24/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit
import SwiftyJSON

class CountrySelectorViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    //MARK: Prpoerties
    var countries = [String]()
    var filteredCountries = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Outlets
    @IBOutlet weak var countriesTableView: UITableView!
    
    override func viewDidLoad() {
        countriesTableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        countriesTableView.tableHeaderView = searchController.searchBar
        populateCountries()
    }
    
    func populateCountries() {
        let path = Bundle.main.path(forResource: "countriesToCities", ofType: "json")
        let jsonFile = NSData(contentsOfFile: path!)
        let json = JSON(jsonFile!)
        var index = 0
        for (key, _) in json {
            if !key.isEmpty{
                countries.append(key)
                index += 1
            }
        }
        countries.sort()
        countriesTableView.reloadData()
    }
    
    //MARK: Actions
    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCountries.count
        }
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CountryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CountryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CountryTableViewCell.")
        }
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.nameLabel.text = filteredCountries[indexPath.row]
        } else {
            cell.nameLabel.text = countries[indexPath.row]
        }
        return cell
    }
    
    //MARK: - Search bar delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }
    
    func filterContentFor(searchText: String, scope: String = "All") {
        filteredCountries = countries.filter { name in
            return name.lowercased().contains(searchText.lowercased())
        }
        countriesTableView.reloadData()
    }

}
