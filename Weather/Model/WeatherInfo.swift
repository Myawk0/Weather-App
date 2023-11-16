//
//  WeatherInfo.swift
//  Weather
//
//  Created by Мявкo on 16.11.23.
//

import Foundation

enum WeatherInfo {
    case thunderstorm
    case drizzle
    case sunRain
    case rain
    case heavyrain
    case snow
    case fog
    case tornado
    case sun
    case cloudSun
    case cloud
    
    init(weatherId: Int) {
        switch weatherId {
            
        // Group 2xx: Thunderstorm
        case 200...232:
            self = .thunderstorm
            
        // Group 3xx: Drizzle
        case 300...321:
            self = .drizzle
            
        // Group 5xx: Rain
        case 500...504:
            self = .sunRain
        case 511:
            self = .rain
        case 520...531:
            self = .heavyrain
            
        // Group 6xx: Snow
        case 600...622:
            self = .snow
            
        // Group 7xx: Atmosphere
        case 701...771:
            self = .fog
        case 781:
            self = .tornado
            
        // Group 800: Clear
        case 800:
            self = .sun
            
        // Group 80x: Clouds
        case 801:
            self = .cloudSun
        case 802...804:
            self = .cloud
        default:
            self = .cloud
        }
    }
    
    var icon: String {
        switch self {
        case .thunderstorm:
            return "cloud.bolt.rain.fill"
        case .drizzle:
            return "cloud.drizzle.fill"
        case .sunRain:
            return "cloud.sun.rain.fill"
        case .rain:
            return "cloud.sleet.fill"
        case .heavyrain:
            return "cloud.heavyrain.fill"
        case .snow:
            return "snowflake"
        case .fog:
            return "cloud.fog.fill"
        case .tornado:
            return "tornado"
        case .sun:
            return "sun.max.fill"
        case .cloudSun:
            return "cloud.sun.fill"
        case .cloud:
            return "cloud.fill"
        }
    }
    
    var background: String {
        switch self {
        case .thunderstorm:
            return "storm"
        case .drizzle:
            return "rain"
        case .sunRain:
            return "rain2"
        case .rain:
            return "rain2"
        case .heavyrain:
            return "rain3"
        case .snow:
            return "overcast"
        case .fog:
            return "overcast"
        case .tornado:
            return "storm"
        case .sun:
            return "sunny"
        case .cloudSun:
            return "sunny-cloudy"
        case .cloud:
            return "cloud"
        }
    }
}
