//
//  MainController.swift
//  Weather
//
//  Created by Мявкo on 18.09.23.
//

import UIKit
import CoreLocation


class WeatherController: UIViewController {
    
    // MARK: - Views
        
    private let weatherView: WeatherView
    private var networkManager = NetworkManager()
    private let locationManager = CLLocationManager()
    
    // MARK: - Init
        
    init() {
        self.weatherView = WeatherView()
        super.init(nibName: nil, bundle: nil)
        
        setupDelegates()
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Appoint mainView as view
    
    override func loadView() {
        super.loadView()
        self.view = weatherView
    }
    
    func setupDelegates() {
        weatherView.delegate = self
        networkManager.delegate = self
        locationManager.delegate = self
    }
}

// MARK: - WeatherViewDelegate

extension WeatherController: WeatherViewDelegate {
    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func cityNameIsPassed(city: String) {
        weatherView.showActivityIndicator = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.networkManager.fetchWeather(cityName: city)
            self.weatherView.showActivityIndicator = false
        }
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherController: NetworkManagerDelegate {
    
    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherView.updateWeatherData(
                name: weather.cityName,
                temp: weather.temperatureString,
                images: weather.weatherInfo,
                description: weather.description,
                icon: URL(string: "\(API.scheme):\(weather.iconName)")
            )
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        weatherView.showActivityIndicator = true
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.networkManager.fetchWeather(coordinates: (lat, lon))
                self.weatherView.showActivityIndicator = false
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
