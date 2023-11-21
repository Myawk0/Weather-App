//
//  String.swift
//  Weather
//
//  Created by Мявкo on 16.11.23.
//

import Foundation

extension String {
    
    func dateFormatter() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE, d MMM"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    var getIconURL: URL? {
        return URL(string: "\(API.scheme):\(self)")
    }
}
