//
//  CitySelectorViewController.swift
//  YAWA
//
//  Created by Mostafa Saleh on 7/24/17.
//  Copyright © 2017 Mostafa Saleh. All rights reserved.
//

import UIKit
import SwiftyJSON

class CitySelectorViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    //MARK: Prpoerties
    var cities = [String]()
    var filteredCities = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        countriesTableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        countriesTableView.tableHeaderView = searchController.searchBar
        populateCountries()
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
            return filteredCities.count
        }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CountryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CountryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CountryTableViewCell.")
        }
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.nameLabel.text = filteredCities[indexPath.row]
        } else {
            cell.nameLabel.text = cities[indexPath.row]
        }
        return cell
    }
    
    func add(cities: [String]) {
        self.cities = cities
        self.cities.sort()
        citiesTableView.reloadData()
    }
    
    //MARK: - Search bar delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }
    
    func filterContentFor(searchText: String, scope: String = "All") {
        filteredCities = cities.filter { name in
            return name.lowercased().contains(searchText.lowercased())
        }
        citiesTableView.reloadData()
    }
    
}
