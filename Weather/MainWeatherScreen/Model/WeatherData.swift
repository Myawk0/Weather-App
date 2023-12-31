//
//  WeatherData.swift
//  Weather
//
//  Created by Мявкo on 20.09.23.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Codable {
    let name: String
}

struct Current: Codable {
    let temp_c: Double
    let is_day: Int //"is_day": 0,
    let condition: Condition
    let wind_kph: Double
    let pressure_mb: Double
    let precip_mm: Double
    let humidity: Int
    let feelslike_c: Double
    let uv: Double
}

struct Condition: Codable {
    let text: String
    let code: Int
    let icon: String
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
}

struct Day: Codable {
    let avgtemp_c: Double
    let condition: Condition
}
