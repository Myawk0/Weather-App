//
//  NetworkError.swift
//  Weather
//
//  Created by Мявкo on 16.11.23.
//

import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

enum ApiError: Error {
    case badResponse
    case unknown
    case unauthorized
    case server
    
    static func byHttpStatusCode(_ code: Int) -> ApiError {
        switch code {
        case 401:
            return .unauthorized
        case 500:
            return .server
        default:
            return .unknown
        }
    }
}
