//
//  WebRequestHandler.swift
//  WeatherApp
//
//  Created by lösen är 0000 on 2018-03-12.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import Foundation

protocol WebRequestHandlerDelegate: class {
    func getWebRequestArray(array: [CityWeather], arrayNr: Int)
}

class WebRequestHandler {
    weak var delegate: WebRequestHandlerDelegate?
    let CORDINATES_KEY = 0
    let GROUP_ID_KEY = 1
    let FIND_KEY = 2
    
    func httpRequest(urlString: String, key: Int) {
        var cityList:[CityWeather] = []
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                }else {
                    if let actualData = data {
                        do{
                            switch key{
                            case self.FIND_KEY:
                                let dataStruct = try JSONDecoder().decode(ApiResponse.self, from: actualData)
                                cityList = self.populateCityWeather(apiResponse: dataStruct)
                            case self.CORDINATES_KEY:
                                let dataStruct = try JSONDecoder().decode(City.self, from: actualData)
                                cityList = self.populateCityWeather(apiResponse: dataStruct)
                            case self.GROUP_ID_KEY:
                                let dataStruct = try JSONDecoder().decode(ApiResponse.self, from: actualData)
                                cityList = self.populateCityWeather(apiResponse: dataStruct)
                            default:
                                cityList = []
                            }
                            
                            DispatchQueue.main.async {
                                self.delegate?.getWebRequestArray(array: cityList, arrayNr: key)
                            }
                            
                        } catch let jsonError{
                            print(jsonError)
                        }
                    }else{
                        print("data was nil")
                    }
                }
                }.resume()
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
    
    func populateCityWeather(apiResponse: City)-> [CityWeather]{
        var cityList: [CityWeather] = []
        cityList.append(CityWeather(
            name: apiResponse.name,
            cityId: apiResponse.id,
            country: apiResponse.sys.country,
            icon: apiResponse.weather[0].icon,
            temp: apiResponse.main.temp,
            windSpeed: apiResponse.wind.speed,
            weatherPrognose: apiResponse.weather[0].main))
    
        return cityList
    }
}

struct ApiResponse: Decodable{
    var list: [City]
}

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







