//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Мявкo on 18.11.23.
//

import UIKit
import CoreLocation


protocol WeatherViewModelType: AnyObject {
    
    var delegate: WeatherViewModelDelegate? { get set }
    var weatherViewController: WeatherView! { get set }
    
    var numberOfDetailedInfoItems: Int { get }
    
    func detailInfoCellViewModel(for indexPath: IndexPath) -> DetailInfoCellViewModelType?
    func nextDaysCellViewModel(for indexPath: IndexPath) -> NextDaysViewModelType?
}

protocol WeatherViewModelDelegate: AnyObject {
    func didChangeLoadingState(_ isLoading: Bool)
    func updateUI(with weather: WeatherModel)
}

class WeatherViewModel: NSObject, WeatherViewModelType {
    
    weak var delegate: WeatherViewModelDelegate?
    weak var weatherViewController: WeatherView!
    
    var details: WeatherDetailInfo?
    var infoNextDays: [WeatherInfoNextDays]?
    
    private var networkManager = NetworkManager()
    private let locationManager = CLLocationManager()
    
    var isLoading: Bool = false {
        didSet {
            delegate?.didChangeLoadingState(isLoading)
        }
    }
    
    override init() {
        super.init()
    }
    
    convenience init(weatherController: WeatherView) {
        self.init()
        weatherViewController = weatherController
        
        setupDelegates()
        
        locationManager.requestWhenInUseAuthorization()
        getCurrentLocation()
    }
    
    func setupDelegates() {
        weatherViewController.delegate = self
        networkManager.delegate = self
        locationManager.delegate = self
    }
    
    var numberOfDetailedInfoItems: Int {
        return 3
    }
    
    func detailInfoCellViewModel(for indexPath: IndexPath) -> DetailInfoCellViewModelType? {
        guard let details = details else { return nil }
        
        return DetailInfoCellViewModel(for: indexPath.row, detailsInfo: details)
    }
    
    func nextDaysCellViewModel(for indexPath: IndexPath) -> NextDaysViewModelType? {
        guard let info = infoNextDays else { return nil }
        
        return NextDaysViewModel(info: info[indexPath.row])
    }
}

// MARK: - WeatherViewDelegate

extension WeatherViewModel: WeatherViewDelegate {
    
    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func cityNameIsPassed(city: String) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.networkManager.fetchWeather(cityName: city)
            self.isLoading = false
        }
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewModel: NetworkManagerDelegate {
    
    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.delegate?.updateUI(with: weather)
            self.details = weather.details
            self.infoNextDays = weather.infoNextDays
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isLoading = true
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.networkManager.fetchWeather(coordinates: (lat, lon))
                self.isLoading = false
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        isLoading = false
    }
}

