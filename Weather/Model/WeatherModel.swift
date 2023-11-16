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
    let details: WeatherDetailInfo
    
    var temperatureString: String {
        return String(format: "%.0f", ceil(temperature))
    }
    
    var weatherInfo: WeatherInfo {
        return WeatherInfo(weatherCode: weatherCode)
    }
}

struct WeatherDetailInfo {
    let indexUV: Double
    let precipitation: Double
    let humidity: Int
}
