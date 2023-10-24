//
//  UIFont+FontStyles.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 24/10/23.
//

import UIKit

extension UIFont {
    
    static var movieBigTitle: UIFont {
        let font = UIFont.systemFont(ofSize: 32, weight: .medium)
        return font
    }
    
    static var smallTags: UIFont {
        let font = UIFont.systemFont(ofSize: 14, weight: .light)
        return font
    }
    
    static var overviewText: UIFont {
        let font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return font
    }
}
