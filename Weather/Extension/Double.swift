//
//  Double.swift
//  Weather
//
//  Created by Мявкo on 22.11.23.
//

import Foundation

extension Double {
    
    var roundDouble: String {
        return String(format: "%.0f", ceil(self))
    }
}
