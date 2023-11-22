//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Мявкo on 18.11.23.
//

import UIKit

protocol WeatherViewModelType: AnyObject, UICollectionViewDataSource, UITableViewDataSource {
    var delegate: WeatherViewModelDelegate? { get set }
    var weatherViewController: WeatherView! { get set }
    
    func detailInfoCellViewModel(for indexPath: IndexPath) -> DetailInfoViewModelType?
    func numberOfDetailedInfoItems() -> Int 
    
    func nextDaysCellViewModel(for indexPath: IndexPath) -> NextDaysViewModelType?
}

