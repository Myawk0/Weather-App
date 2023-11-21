//
//  NextDaysViewModel.swift
//  Weather
//
//  Created by Мявкo on 21.11.23.
//

import Foundation

protocol NextDaysViewModelType: AnyObject {
    var infoNextDay: WeatherInfoNextDays! { get set }
    
    var iconName: URL? { get }
    var degreesString: String { get }
    var formattedDate: String? { get }
}

class NextDaysViewModel: NextDaysViewModelType {

    var infoNextDay: WeatherInfoNextDays!
    
    init(info: WeatherInfoNextDays) {
        self.infoNextDay = info
    }
    
    var iconName: URL? {
        return infoNextDay.iconName.getIconURL
    }
    
    var degreesString: String {
        return String(format: "%.0f", ceil(infoNextDay.avgTemperature)) + "°C"
    }
    
    var formattedDate: String? {
        return infoNextDay.date.dateFormatter()
    }
}
