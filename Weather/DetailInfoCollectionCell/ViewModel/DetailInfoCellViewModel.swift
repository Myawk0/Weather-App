//
//  DetailInfoCellViewModel.swift
//  Weather
//
//  Created by Мявкo on 20.11.23.
//

import Foundation

protocol DetailInfoCellViewModelType: AnyObject {
    
    var detailsInfo: WeatherDetailInfo! { get set }
    var cellIndex: Int { get set }
    
    var indexUV: String { get }
    var indicatorIndexUV: String { get }
    var humidity: String { get }
    var wind: String { get }
    
    func getWeatherInfoValue() -> (value: String, unit: String)
}

class DetailInfoCellViewModel: DetailInfoCellViewModelType {
    
    var detailsInfo: WeatherDetailInfo!
    var cellIndex: Int
    
    init(for cellIndex: Int, detailsInfo: WeatherDetailInfo) {
        self.cellIndex = cellIndex
        self.detailsInfo = detailsInfo
    }
    
    var indexUV: String {
        return String(format: "%.0f", detailsInfo.indexUV)
    }
    
    var indicatorIndexUV: String {
        return defineIndexUV(index: Int(indexUV) ?? 1)
    }
    
    var humidity: String {
        return "\(detailsInfo.humidity)"
    }
    
    var wind: String {
        return "\(detailsInfo.wind)"
    }
    
    func getWeatherInfoValue() -> (value: String, unit: String) {
        switch cellIndex {
        case 0:
            return (indexUV, indicatorIndexUV)
        case 1:
            return (humidity, "%")
        case 2:
            return (wind, "km/h")
        default:
            return ("", "")
        }
    }
    
    private func defineIndexUV(index: Int) -> String {
        switch index {
        case 0...2:
            return "Low"
        case 3...5:
            return "Moderate"
        case 6...7:
            return "High"
        case 8...10:
            return "Very High"
        case 11...Int.max:
            return "Extreme"
        default:
            return ""
        }
    }
}
