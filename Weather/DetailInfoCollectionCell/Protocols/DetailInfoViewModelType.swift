//
//  DetailInfoViewModelType.swift
//  Weather
//
//  Created by Мявкo on 22.11.23.
//

import Foundation

protocol DetailInfoViewModelType: AnyObject {
    
    var detailsInfo: WeatherDetailInfo! { get set }
    var cellIndex: Int { get set }
    
    func getWeatherInfoValue() -> (value: String, unit: String)
}
