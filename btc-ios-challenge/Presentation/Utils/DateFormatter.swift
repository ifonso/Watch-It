//
//  DateFormatter.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 28/09/23.
//

import Foundation

func getDateFrom(_ date: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: date)
}
