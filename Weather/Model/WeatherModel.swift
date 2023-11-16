//
//  WeatherModel.swift
//  Weather
//
//  Created by Мявкo on 20.09.23.
//

import Foundation

struct WeatherModel {
    let weatherCode: Int
    let cityName: String
    let temperature: Double
    let description: String
    let iconName: String
    
    var temperatureString: String {
        return String(format: "%.0f", ceil(temperature))
    }
    
    var weatherInfo: WeatherInfo {
        return WeatherInfo(weatherCode: weatherCode)
    }
}
