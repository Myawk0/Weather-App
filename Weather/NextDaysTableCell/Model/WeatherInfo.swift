//
//  WeatherInfo.swift
//  Weather
//
//  Created by Мявкo on 16.11.23.
//

import Foundation

enum WeatherInfo: Int {
    case thunderstorm
    case drizzle
    case sunRain
    case rain
    case heavyrain
    case snow
    case fog
    case tornado
    case sunny
    case partlyCloudy
    case cloudy
    
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
        case .sunny:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
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
        case .sunny:
            return "sunny"
        case .partlyCloudy:
            return "sunny-cloudy"
        case .cloudy:
            return "cloud"
        }
    }
    
    init(weatherCode: Int) {
        switch weatherCode {
            
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
        
            
            
            
        // MARK: - he
        
        // "day": "Sunny",
        // "night": "Clear",
        case 1000:
            self = .sunny
            
        // Partly cloudy
        case 1003:
            self = .partlyCloudy
        // Cloudy
        case 1006:
            self = .cloudy
        // Overcast (пасмурно, надо сделать серые облака)
        case 1009:
            self = .cloudy
        // Mist (туман)
//        case 1030:
//            self = .mist
//        // Patchy rain possible
//        case 1063:
//            self = .sunRain
//        // Patchy snow possible
//        case 1066:
//            self = .sunSnow
//        // Patchy sleet possible (дождь и снег с солнцем)
//        case 1069:
//            self = .sunRainSnow
        // Patchy freezing drizzle possible (Возможен кратковременный ледяной дождь)
        case 1072:
            self = .rain
            
        // Thundery outbreaks possible
        case 1087:
            self = .thunderstorm
        // Blowing snow
        case 1114:
            self = .snow
        // Blizzard (метель)
        case 1117:
            self = .snow
        // Fog (Туман)
        case 1135:
            self = .fog
        // Freezing fog
        case 1147:
            self = .fog
        // Patchy light drizzle - Небольшой мелкий дождь
        case 1150:
            self = .rain
        // Light drizzle - Легкая морось
        case 1153:
            self = .rain
        
        
        // Freezing drizzle - Изморозь
        case 1168:
            self = .fog
        // Heavy freezing drizzle - Сильный ледяной дождь
        case 1171:
            self = .heavyrain
        // Patchy light rain - Небольшой дождь
        case 1180:
            self = .rain
        // Light rain - Легкий дождь
        case 1183:
            self = .rain
        // Moderate rain at times - Временами умеренный дождь
        case 1186:
            self = .rain
        // Moderate rain - Умеренный дождь
        case 1189:
            self = .rain
        // Heavy rain at times - Временами сильный дождь
        case 1192:
            self = .heavyrain
        // Heavy rain - Cильный дождь
        case 1195:
            self = .heavyrain
        // Light freezing rain - Легкий ледяной дождь
        case 1198:
            self = .rain
        // Moderate or heavy freezing rain - Умеренный или сильный ледяной дождь
        case 1201:
            self = .rain
        // Light sleet - Легкий мокрый снег
        case 1204:
            self = .snow
        // Moderate or heavy sleet - Умеренный или сильный мокрый снег
        case 1207:
            self = .heavyrain
        // Patchy light snow - Небольшой мелкий снег
        case 1210:
            self = .heavyrain
        // Light snow - Легкий снег
        case 1213:
            self = .snow
        // Patchy moderate snow - Неровный умеренный снег
        case 1216:
            self = .snow
        // Moderate snow - Умеренный снег
        case 1219:
            self = .snow
        // Patchy heavy snow - Неровный сильный снег
        case 1222:
            self = .snow
        // Heavy snow - сильный снег
        case 1225:
            self = .snow
        // Ice pellets - Ледяная крупа
        case 1237:
            self = .snow
        // Light rain shower - Небольшой дождь моросит
        case 1240:
            self = .rain
        // Moderate or heavy rain shower - Умеренный или сильный ливень
        case 1243:
            self = .heavyrain
        // Torrential rain shower - Проливной ливень
        case 1246:
            self = .heavyrain
        // Light sleet showers - Небольшой ливень с мокрым снегом
        case 1249:
            self = .snow
            
            // Moderate or heavy sleet showers - Умеренный или сильный ливень с мокрым снегом
            case 1252:
                self = .rain
            // Light snow showers - Легкий снегопад
            case 1255:
                self = .snow
            // Moderate or heavy snow showers - Умеренный или сильный снегопад
            case 1258:
                self = .snow
            // Light showers of ice pellets - Легкий дождь ледяных крупинок
            case 1261:
                self = .snow
            // Moderate or heavy showers of ice pellets - Умеренные или сильные ливни ледяной крупы
            case 1264:
                self = .rain
            // Patchy light rain with thunder - Небольшой дождь с грозой
            case 1273:
                self = .heavyrain
            // Moderate or heavy rain with thunder - Умеренный или сильный дождь с грозой
            case 1276:
                self = .heavyrain
            // Patchy light snow with thunder - Небольшой снег с грозой
            case 1279:
                self = .snow
            // Moderate or heavy snow with thunder - Умеренный или сильный снег с грозой
            case 1282:
                self = .snow
            
            
        default:
            self = .cloudy
        }
    }
}
