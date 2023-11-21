//
//  WeatherInfoData.swift
//  Weather
//
//  Created by Мявкo on 17.11.23.
//

import UIKit

enum WeatherInfoData: Int {
    case indexUV = 0
    case humidity = 1
    case wind = 2
    
    var icon: UIImage? {
        switch self {
        case .indexUV:
            return UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal)
        case .humidity:
            return UIImage(systemName: "humidity")
        case .wind:
            return UIImage(systemName: "wind")?.withTintColor(.systemCyan, renderingMode: .alwaysOriginal)
        }
    }
    
    var title: String {
        switch self {
        case .indexUV:
            return "UV Index"
        case .humidity:
            return "Humidity"
        case .wind:
            return "Wind"
        }
    }
}
