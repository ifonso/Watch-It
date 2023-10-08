//
//  Double+RatingFormatter.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 08/10/23.
//

import Foundation

extension Double {
    static func ratingFormat(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.decimalSeparator = ","
        
        guard let rating = numberFormatter.string(from: NSNumber(value: number))
        else { return "0,0"}
        
        return rating
    }
}
