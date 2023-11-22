//
//  NetworkManager.swift
//  Weather
//
//  Created by Мявкo on 16.11.23.
//

import Alamofire
import UIKit

protocol NetworkManagerDelegate: AnyObject {
    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    weak var delegate: NetworkManagerDelegate?
    
    // Make parameters
    private func makeParameters(for endpoint: Endpoint, city: String?, coordinates: (latitude: Double, longitude: Double)?) -> [String: String] {
        
        var parameters = [String: String]()
        
        parameters["key"] = API.apiKey
        parameters["days"] = "\(API.countNextDays)"
        
        switch endpoint {
        case .cityLocation:
            parameters["q"] = city
        case .coordinatesLocation:
            guard let coordinates = coordinates else { break }
            parameters["q"] = "\(coordinates.latitude),\(coordinates.longitude)"
        }
        
        return parameters
    }

    // Create URL for API method
    func createURL(for endPoint: Endpoint, city: String? = nil, coordinates: (latitude: Double, longitude: Double)? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = endPoint.path
        
        components.queryItems = makeParameters(for: endPoint, city: city, coordinates: coordinates).compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    
        return components.url
    }
    
    // Method for making task
    func makeTask<T: Decodable>(for url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(.transportError(error)))
            }
        }
    }
    
    private func getWeatherInfoNextDays(data: WeatherData) -> [WeatherInfoNextDays] {
        var infoNextDays = [WeatherInfoNextDays]()
        for day in 1...API.countNextDays - 1 {
            let avgTemp = data.forecast.forecastday[day].day.avgtemp_c
            let iconName = data.forecast.forecastday[day].day.condition.icon
            let date = data.forecast.forecastday[day].date
            infoNextDays.append(WeatherInfoNextDays(avgTemperature: avgTemp, iconName: iconName, date: date))
        }
        return infoNextDays
    }
    
    private func getWeatherDetailInfo(data: WeatherData) -> WeatherDetailInfo {
        return WeatherDetailInfo(
            indexUV: data.current.uv,
            wind: data.current.wind_kph,
            humidity: data.current.humidity
        )
    }
    
    private func getWeatherModel(data: WeatherData, details: WeatherDetailInfo, nextDays: [WeatherInfoNextDays]) -> WeatherModel {
        return WeatherModel(
            weatherCode: data.current.condition.code,
            cityName: data.location.name,
            temperature: data.current.temp_c,
            description: data.current.condition.text,
            iconName: data.current.condition.icon,
            details: details,
            infoNextDays: nextDays
        )
    }
}

extension NetworkManager {
    
    // MARK: - Method to get Decoded Data
    
    func performWeatherRequest(with url: URL, completion: @escaping (Result<WeatherModel, NetworkError>) -> Void) {
        makeTask(for: url) { (result: Result<WeatherData, NetworkError>) in
            switch result {
            case .success(let decodedData):
                
                let infoNextDays = self.getWeatherInfoNextDays(data: decodedData)
                let detailsInfo = self.getWeatherDetailInfo(data: decodedData)
                let weather = self.getWeatherModel(data: decodedData, details: detailsInfo, nextDays: infoNextDays)
                
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - GET Weather by City name
    
    func fetchWeather(cityName: String) {
        guard let url = createURL(for: .cityLocation, city: cityName) else { return }
        performWeatherRequest(with: url) { result in
            switch result {
            case .success(let weatherModel):
                self.delegate?.didUpdateWeather(self, weather: weatherModel)
            case .failure(let error):
                print("Error getting weather info by City Name: \(error)")
            }
        }
    }
    
    // MARK: - GET Weather by current Coordinates
    
    func fetchWeather(coordinates: (latitude: Double, longitude: Double)) {
        guard let url = createURL(for: .coordinatesLocation, coordinates: coordinates) else { return }
        performWeatherRequest(with: url) { result in
            switch result {
            case .success(let weatherModel):
                self.delegate?.didUpdateWeather(self, weather: weatherModel)
            case .failure(let error):
                print("Error getting weather info by Current Coordinates: \(error)")
            }
        }
    }
}

