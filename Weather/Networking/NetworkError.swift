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
