//
//  UIColor.swift
//  Weather
//
//  Created by Мявкo on 17.11.23.
//

import UIKit

extension UIView {
    func setGradientBackground() {
        let gradientColors = [
            UIColor(red: 210/255, green: 226/255, blue: 246/255, alpha: 1).cgColor,
            UIColor(red: 252/255, green: 253/255, blue: 254/255, alpha: 1).cgColor
        ]
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        layer.insertSublayer(gradientLayer, at: 0)
    }
}

