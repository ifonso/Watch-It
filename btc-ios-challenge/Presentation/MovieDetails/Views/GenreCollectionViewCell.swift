//
//  GenreCollectionViewCell.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 07/10/23.
//

import UIKit

final class GenreCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: GenreCollectionViewCell.self)
    
    private lazy var genreTextView: UILabel = {
        var textView = UILabel()
        textView.text = "Genre"
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setGenreName(name: String) {
        genreTextView.text = name
    }
    
    private func setupViews() {
        addSubview(genreTextView)
        // setup self
        backgroundColor = .gray
        clipsToBounds = true
        layer.cornerRadius = 12
    }
    
    private func setupConstraints() {
        genreTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            genreTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Sizes.System.medium),
            genreTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Sizes.System.medium),
            genreTextView.topAnchor.constraint(equalTo: topAnchor, constant: Sizes.System.small),
            genreTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Sizes.System.small)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
