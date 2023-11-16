//
//  WeatherModel.swift
//  Weather
//
//  Created by Мявкo on 20.09.23.
//

import Foundation


struct WeatherModel {
    let weatherId: Int
    let cityName: String
    let temperature: Double
    let description: String
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var weatherInfo: WeatherInfo {
        return WeatherInfo(weatherId: weatherId)
    }
}
