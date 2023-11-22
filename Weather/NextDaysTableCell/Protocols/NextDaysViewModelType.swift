//
//  NextDaysViewModelType.swift
//  Weather
//
//  Created by Мявкo on 22.11.23.
//

import Foundation

protocol NextDaysViewModelType: AnyObject {
    var infoNextDay: WeatherInfoNextDays! { get set }
    
    var iconName: URL? { get }
    var degreesString: String { get }
    var formattedDate: String? { get }
}
