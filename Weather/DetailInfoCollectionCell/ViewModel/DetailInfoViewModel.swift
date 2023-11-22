//
//  DetailInfoCellViewModel.swift
//  Weather
//
//  Created by Мявкo on 20.11.23.
//

import Foundation

class DetailInfoViewModel: DetailInfoViewModelType {
    
    var detailsInfo: WeatherDetailInfo!
    var cellIndex: Int
    
    init(for cellIndex: Int, detailsInfo: WeatherDetailInfo) {
        self.cellIndex = cellIndex
        self.detailsInfo = detailsInfo
    }
    
    private var indexUV: String {
        return detailsInfo.indexUV.roundDouble
    }
    
    private var indicatorIndexUV: String {
        return defineIndexUV(index: Int(indexUV) ?? 1)
    }
    
    private var humidity: String {
        return "\(detailsInfo.humidity)"
    }
    
    private var wind: String {
        return "\(detailsInfo.wind)"
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
}
