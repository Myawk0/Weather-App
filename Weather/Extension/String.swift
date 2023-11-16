//
//  String.swift
//  Weather
//
//  Created by Мявкo on 16.11.23.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()

        return firstLetter + remainingLetters
    }
}
