//
//  GenreCollectionViewLayout.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 07/10/23.
//

import UIKit

final class GenreCollectionViewLayout: UICollectionViewFlowLayout {
    
    let cellSpacing: CGFloat = 8
    let lineSpacing: CGFloat = 10.0
    let insents = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0)

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = lineSpacing
        self.sectionInset = insents
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
