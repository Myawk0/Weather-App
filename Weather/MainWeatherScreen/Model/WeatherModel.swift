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
    let infoNextDays: [WeatherInfoNextDays]
    
    var weatherInfo: WeatherInfo {
        return WeatherInfo(weatherCode: weatherCode)
    }
}

struct WeatherDetailInfo {
    let indexUV: Double
    let wind: Double
    let humidity: Int
}

struct WeatherInfoNextDays {
    let avgTemperature: Double
    let iconName: String
    let date: String
}
