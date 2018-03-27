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
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var clothesTextView: UITextField!
    var city: CityWeather!
    let FAVORITE_KEY = "favorites"
    var tableView: TableViewController!
    var row: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = city.name
        self.cityLabel.text = city.name
        self.tempLabel.text = String(format: "%.1f", city.temp)
        self.windspeedLabel.text = "Windspeed: " + String(format: "%.2f", city.windSpeed) + " m/s"
        self.weatherStatusLabel.text = city.weatherPrognose
        neededClothes()
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
                tableView.sectionArray[1].remove(at: row)
            }else {
                arrayFavorites.append("\(city.cityId)")
                defaults.set(arrayFavorites, forKey: FAVORITE_KEY)
                tableView.sectionArray[1].append(city)
            }
        } else {
            let arrayFavorites = ["\(city.cityId)"]
            defaults.set(arrayFavorites, forKey: FAVORITE_KEY)
            tableView.sectionArray[1].append(city)
        }
        tableView.tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func neededClothes(){
        if city.temp >= 18 && city.windSpeed < 5 {
            clothesTextView.text = "t-shirt and shorts"
        } else if city.temp >= 5 && city.windSpeed < 12 {
            clothesTextView.text = "It's a bit cold, take a jacket"
        } else {
            clothesTextView.text = "It's very cold outside, take a thick jacket"
        }
        
        /*if rain != nil {
            print("It's raining! You need an umbrella")
        }*/
    }
    
}

