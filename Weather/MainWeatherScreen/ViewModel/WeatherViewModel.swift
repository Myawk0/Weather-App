//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Мявкo on 18.11.23.
//

import UIKit
import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
    func didChangeLoadingState(_ isLoading: Bool)
    func updateUI(with weather: WeatherModel)
}

class WeatherViewModel: NSObject, WeatherViewModelType {
    
    weak var delegate: WeatherViewModelDelegate?
    weak var weatherViewController: WeatherView!
    
    private var details: WeatherDetailInfo?
    private var infoNextDays: [WeatherInfoNextDays]?
    
    private var networkManager = NetworkManager()
    private let locationManager = CLLocationManager()
    
    private var isLoading: Bool = false {
        didSet {
            delegate?.didChangeLoadingState(isLoading)
        }
    }
    
    // MARK: - Init
    
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
    
    // MARK: - Delegates
    
    func setupDelegates() {
        weatherViewController.delegate = self
        networkManager.delegate = self
        locationManager.delegate = self
    }
    
    // MARK: - Method to DetailInfoCellViewModel
    
    func detailInfoCellViewModel(for indexPath: IndexPath) -> DetailInfoViewModelType? {
        guard let details = details else { return nil }
        
        return DetailInfoViewModel(for: indexPath.row, detailsInfo: details)
    }
    
    // count of Detailed Items
    func numberOfDetailedInfoItems() -> Int {
        return 3
    }
    
    // MARK: - Method to NextDaysViewModel
    
    func nextDaysCellViewModel(for indexPath: IndexPath) -> NextDaysViewModelType? {
        guard let info = infoNextDays else { return nil }
        
        return NextDaysViewModel(info: info[indexPath.row])
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDetailedInfoItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.DetailInfo.cellIdentifier, for: indexPath) as? DetailInfoCell else { return UICollectionViewCell() }
        
        cell.viewModel = detailInfoCellViewModel(for: indexPath)
        cell.cellIndex = indexPath.row
        
        return cell
    }
}

// MARK: - UITableViewDataSource

extension WeatherViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return API.countNextDays - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.NextDaysInfo.cellIdentifier, for: indexPath) as? NextDaysCell else { return UITableViewCell() }
        
        cell.viewModel = nextDaysCellViewModel(for: indexPath)
        
        return cell
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
