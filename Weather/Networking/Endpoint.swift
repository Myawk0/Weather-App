//
//  Endpoint.swift
//  Weather
//
//  Created by Мявкo on 16.11.23.
//

import Foundation

enum Endpoint {
    case cityLocation
    case coordinatesLocation

    var path: String {
        switch self {
        case .cityLocation, .coordinatesLocation:
            return "/data/2.5/weather"
        }
    }
}
