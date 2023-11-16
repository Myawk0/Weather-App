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
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    // MARK: - Init
        
    init() {
        self.weatherView = WeatherView()
        super.init(nibName: nil, bundle: nil)
        
        setupDelegates()
        //locationManager.requestWhenInUseAuthorization()
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
        weatherManager.delegate = self
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
            self.weatherManager.fetchWeather(cityName: city)
            self.weatherView.showActivityIndicator = false
        }
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherView.updateWeatherImages(from: weather.weatherName)
            self.weatherView.updateTemperature(with: weather.temperatureString)
            self.weatherView.updateCityName(with: weather.cityName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
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
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            weatherView.showActivityIndicator = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
