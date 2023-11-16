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
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var weatherName: (icon: String, back: String) {
        switch weatherId {
            
        // Group 2xx: Thunderstorm
        case 200...232:
            return ("cloud.bolt.rain", "storm")
            
        // Group 3xx: Drizzle
        case 300...321:
            return ("cloud.drizzle", "rain")
            
        // Group 5xx: Rain
        case 500...504:
            return ("cloud.sun.rain", "rain2")
        case 511:
            return ("cloud.sleet", "rain2")
        case 520...531:
            return ("cloud.heavyrain", "rain3")
            
        // Group 6xx: Snow
        case 600...622:
            return ("snowflake", "overcast")
            
        // Group 7xx: Atmosphere
        case 701...771:
            return ("cloud.fog", "overcast")
        case 781:
            return ("tornado", "storm")
            
        // Group 800: Clear
        case 800:
            return ("sun.max", "sunny")
            
        // Group 80x: Clouds
        case 801:
            return ("cloud.sun", "sunny-cloudy")
        case 802...804:
            return ("cloud", "cloud")
            
        default:
            return ("", "")
        }
    }
}
