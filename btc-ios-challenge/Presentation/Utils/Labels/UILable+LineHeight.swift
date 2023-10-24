//
//  UILable+LineHeight.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 24/10/23.
//

import UIKit

extension UILabel {
    func setLineSpacing(with lineSpacing: CGFloat, lineHeightMultiple: CGFloat = 1) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString: NSMutableAttributedString
        
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
