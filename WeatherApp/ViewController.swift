//
//  ViewController.swift
//  WeatherApp
//
//  Created by lösen är 0000 on 2018-03-07.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    var city: CityWeather!
    let FAVORITE_KEY = "favorites"
    var tableView: TableViewController!
    var row: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = city.name
        self.cityLabel.text = city.name
        self.tempLabel.text = String(city.temp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func favoriteButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        if var arrayFavorites = defaults.array(forKey: FAVORITE_KEY) as? [String] {
            if arrayFavorites.contains("\(city.cityId)"){
                let filteredArray = arrayFavorites.filter({$0 != "\(city.cityId)"})
                defaults.set(filteredArray, forKey: FAVORITE_KEY)
                //Todo delete city from favoriteArray in tableview and reload that tableview without calling api.
                tableView.sectionArray[1].remove(at: row)
            }else {
                arrayFavorites.append("\(city.cityId)")
                defaults.set(arrayFavorites, forKey: FAVORITE_KEY)
                //Todo add city to favoriteArray in tableview and reload data without calling api
                tableView.sectionArray[1].append(city)
            }
        } else {
            let arrayFavorites = ["\(city.cityId)"]
            defaults.set(arrayFavorites, forKey: FAVORITE_KEY)
            //Todo add city to favoriteArray in tableview and reload data without calling api
            tableView.sectionArray[1].append(city)
        }
        tableView.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
}

