//
//  NextDaysViewModel.swift
//  Weather
//
//  Created by Мявкo on 21.11.23.
//

import Foundation

class NextDaysViewModel: NextDaysViewModelType {

    var infoNextDay: WeatherInfoNextDays!
    
    init(info: WeatherInfoNextDays) {
        self.infoNextDay = info
    }
    
    var iconName: URL? {
        return infoNextDay.iconName.getIconURL
    }
    
    var degreesString: String {
        return infoNextDay.avgTemperature.roundDouble + "°C"
    }
    
    var formattedDate: String? {
        return infoNextDay.date.dateFormatter()
    }
}
