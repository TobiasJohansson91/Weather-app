//
//  TableViewController.swift
//  WeatherApp
//
//  Created by lösen är 0000 on 2018-03-08.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate, WebRequestHandlerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var graphButton: UIBarButtonItem!
    var sectionArray: [[CityWeather]] = [[],[],[]]
    var filteredData: [String]!;
    let locationManager = CLLocationManager()
    var cordinates = ["lat":37.33, "long":-122.024]
    let request = WebRequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "weatherBackground"))
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        request.delegate = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
        disableGraphButton()
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
        requestWithId()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            cordinates["lat"] = location.coordinate.latitude
            cordinates["long"] = location.coordinate.longitude
        }
        requestWithCordinates()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        requestWithCordinates()
    }
    
    func requestWithCordinates(){
        request.httpRequest(urlString: "http://api.openweathermap.org/data/2.5/weather?lat=\(cordinates["lat"]!)&lon=\(cordinates["long"]!)&units=metric&APPID=10b122ec245db62e54a3bc59d9b36b82", key: request.CORDINATES_KEY)
    }
    
    func requestWithId(){
        if let favoritesArray = UserDefaults.standard.array(forKey: "favorites") as? [String]{
            let arrayString = favoritesArray.joined(separator: ",")
            
            request.httpRequest(urlString: "http://api.openweathermap.org/data/2.5/group?id=\(arrayString)&units=metric&APPID=10b122ec245db62e54a3bc59d9b36b82", key: request.GROUP_ID_KEY)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! MyTableViewCell
        let city = sectionArray[indexPath.section][indexPath.row]
        cell.cityLabel.text = city.name + ", " + city.country
        cell.tempLabel.text = String(city.temp) + " °C"
        cell.weatherIcon.image = UIImage(named: city.icon)
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.backgroundColor = .clear
        cell.cellId = indexPath.row
        cell.section = indexPath.section
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Your location"
        case 1:
            return "Favorites"
        case 2:
            return "Search"
        default:
            return ""
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            request.httpRequest(urlString: "http://api.openweathermap.org/data/2.5/find?q=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&type=like&units=metric&APPID=10b122ec245db62e54a3bc59d9b36b82", key: request.FIND_KEY)
        } else{
            sectionArray[2] = []
            tableView.reloadData()
        }
    }
    
    func getWebRequestArray(array: [CityWeather], arrayNr: Int) {
        sectionArray[arrayNr] = array
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CityWeatherSegue" {
            let cell = sender as! MyTableViewCell
            let destView = segue.destination as! ViewController
            destView.city = sectionArray[cell.section][cell.cellId]
            destView.tableView = self
            destView.row = cell.cellId
        }else if segue.identifier == "GraphSegue"{
            let indexPaths = tableView.indexPathsForSelectedRows
            var graphArray: [CityWeather] = []
            for index in indexPaths! {
                graphArray.append(sectionArray[index.section][index.row])
            }
            let destView = segue.destination as! ViewControllerGraph
            destView.cityArray = graphArray
            chooseButtonClicked("self")
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isEditing && identifier == "CityWeatherSegue" {
            return false
        }
        return true
    }
    
    @IBAction func chooseButtonClicked(_ sender: Any) {
        setEditing(!isEditing, animated: true)
        if !isEditing {
           disableGraphButton()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRows = tableView.indexPathsForSelectedRows
        if isEditing && selectedRows!.count >= 2 && selectedRows!.count <= 5 {
            graphButton.title = "Graph"
            graphButton.isEnabled = true
        }else {
            disableGraphButton()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedRows = tableView.indexPathsForSelectedRows
        if isEditing && selectedRows != nil && selectedRows!.count < 2 || selectedRows != nil && selectedRows!.count > 5{
            disableGraphButton()
       }else {
            graphButton.title = "Graph"
            graphButton.isEnabled = true
        }
    }
    func disableGraphButton(){
        graphButton.title = ""
        graphButton.isEnabled = false
    }
}
