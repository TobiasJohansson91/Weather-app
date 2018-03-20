//
//  WebRequestHandler.swift
//  WeatherApp
//
//  Created by lösen är 0000 on 2018-03-12.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import Foundation

class WebRequestHandler {
    
    func httpRequest(urlString: String) -> [CityWeather] {
        var cityList:[CityWeather] = []
        let url: URL = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print(error)
            }else {
                if let actualData = data {
                    do{
                        var dataArray = try JSONDecoder().decode(ApiResponse.self, from: actualData)
                        cityList = populateCityWeather(apiResponse: dataArray)
                    } catch let jsonError{
                        print(jsonError)
                    }
                }else{
                    print("data was nil")
                }
            }
            }.resume()
        return cityList
    }
}

struct ApiResponse: Decodable{
    var list: [City]
    
    struct City: Decodable{
        let id: Int
        let name: String
        let main: MainTemp
        let sys: SysCountry
        let weather: [Weather]
        let wind: WindSpeed
        
        struct MainTemp: Decodable{
            let temp: Float
        }
        struct SysCountry: Decodable{
            let country: String
        }
        struct Weather: Decodable{
            let icon: String
            let main: String
        }
        struct WindSpeed: Decodable{
            let speed: Float
        }
    }
}

struct CityWeather{
    let name: String
    let cityId: Int
    let country: String //sys country
    let icon: String //weather icon
    let temp: Float //main temp
    let windSpeed: Float //wind speed
    let weatherPrognose: String //weather main
    
    init(name: String, cityId: Int, country: String, icon: String, temp: Float, windSpeed: Float, weatherPrognose: String) {
        self.name = name
        self.cityId = cityId
        self.country = country
        self.icon = icon
        self.temp = temp
        self.windSpeed = windSpeed
        self.weatherPrognose = weatherPrognose
    }
}

func populateCityWeather(apiResponse: ApiResponse)->[CityWeather]{
    var cityList: [CityWeather] = []
    for item in  apiResponse.list{
        cityList.append(CityWeather(
            name: item.name,
            cityId: item.id,
            country: item.sys.country,
            icon: item.weather[0].icon,
            temp: item.main.temp,
            windSpeed: item.wind.speed,
            weatherPrognose: item.weather[0].main))
    }
    return cityList
}



