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
    @IBOutlet weak var clothesTextView: UITextView!
    @IBOutlet weak var cityLabelLeftConstrint: NSLayoutConstraint!
    @IBOutlet weak var cityLabelRightConstrint: NSLayoutConstraint!
    @IBOutlet weak var tempLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var tempLabelRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherIconImage: UIImageView!
    
    var city: CityWeather!
    let FAVORITE_KEY = "favorites"
    var tableView: TableViewController!
    var row: Int!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = city.name
        self.cityLabel.text = city.name
        self.tempLabel.text = "\(String(format: "%.1f", city.temp)) °C"
        self.windspeedLabel.text = "Windspeed: " + String(format: "%.2f", city.windSpeed) + " m/s"
        self.weatherStatusLabel.text = "Weather: \(city.weatherPrognose)"
        clothesTextView.text = neededClothes()
        
        let halfViewWidth = view.frame.width/2
        cityLabelLeftConstrint.constant = halfViewWidth
        cityLabelRightConstrint.constant = halfViewWidth
        tempLabelLeftConstraint.constant = halfViewWidth
        tempLabelRightConstraint.constant = halfViewWidth
        windspeedLabel.alpha = 0
        weatherStatusLabel.alpha = 0
        clothesTextView.alpha = 0
        
        weatherIconImage.image = UIImage(named: "\(city.icon)")
        weatherIconImage.layer.cornerRadius = weatherIconImage.frame.height/2
        weatherIconImage.clipsToBounds = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2) {
            self.cityLabelLeftConstrint.constant = 132
            self.cityLabelRightConstrint.constant = 132
            self.tempLabelLeftConstraint.constant = 70
            self.tempLabelRightConstraint.constant = 70
            self.windspeedLabel.alpha = 1
            self.weatherStatusLabel.alpha = 1
            self.clothesTextView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [weatherIconImage])
        gravity.magnitude = 0.2
        collision = UICollisionBehavior(items: [weatherIconImage])
        collision.translatesReferenceBoundsIntoBoundary = true
        let itemBehave = UIDynamicItemBehavior(items: [weatherIconImage])
        itemBehave.elasticity = 0.6
        animator.addBehavior(collision)
        animator.addBehavior(gravity)
        animator.addBehavior(itemBehave)
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
    
    func neededClothes()-> String{
        var clothesString = ""
        if city.temp >= 18 && city.windSpeed < 5 {
            clothesString += "It's hot, take t-shirt and shorts. "
        } else if city.temp >= 5 && city.windSpeed < 12 {
            clothesString += "It's a bit cold, take a jacket. "
        } else {
            clothesString += "It's very cold outside, take a thick jacket. "
        }
        if city.weatherPrognose == "Rain" {
            clothesString += "\nIt's raining! You need an umbrella."
        }
        return clothesString
    }
}

