//
//  GenreCollectionView.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 08/10/23.
//

import UIKit

final class GenreCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
