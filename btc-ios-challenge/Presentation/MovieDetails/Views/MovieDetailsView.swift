//
//  MovieDetailsView.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 07/10/23.
//

import UIKit
import Combine

final class MovieDetailsView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var posterImageRepository: PosterImageRepositoryType?
    private var imageLoadTask = Set<AnyCancellable>() {
        willSet { imageLoadTask.forEach({ $0.cancel() }) }
    }
    
    var genresCollection: UICollectionView = {
        var layout = GenreCollectionViewLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        var collection = GenreCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collection.backgroundColor = .clear
        return collection
    }()
    
    // MARK: Poster content
    private lazy var posterViewContainer: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    private lazy var blurContainerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        var effectsView = UIVisualEffectView(effect: blurEffect)
        effectsView.clipsToBounds = true
        effectsView.layer.cornerRadius = 14
        return effectsView
    }()
    
    private lazy var ratingIconView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "heart.fill", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var ratingTextView: UILabel = {
        var label = UILabel()
        label.text = "0,0"
        return label
    }()
    
    // MARK: Text Content
    private lazy var titleView: UILabel = {
        var label = UILabel()
        label.text = "Movie Title"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private lazy var overviewView: UILabel = {
        var label = UILabel()
        label.text = "Movie overview."
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func config(movie: MovieDetailsDTO,
                posterImageRepository: PosterImageRepositoryType
    ) {
        self.posterImageRepository = posterImageRepository
        
        titleView.text = movie.title
        overviewView.text = movie.overview
        ratingTextView.text = Double.ratingFormat(movie.rating)
        setupPoster(url: movie.posterImageUrlString)
    }
    
    private func setupPoster(url: String) {
        Task { @MainActor [weak self] in
            self?.posterViewContainer.image = await self?.posterImageRepository?.loadImage(from: url)
            print("Done")
        }
        .store(in: &imageLoadTask)
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        blurContainerView.contentView.addSubview(ratingIconView)
        blurContainerView.contentView.addSubview(ratingTextView)
        posterViewContainer.addSubview(blurContainerView)
        // Containers
        contentView.addSubview(posterViewContainer)
        contentView.addSubview(titleView)
        contentView.addSubview(genresCollection)
        contentView.addSubview(overviewView)
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    private func setupConstraints() {
        posterViewContainer.translatesAutoresizingMaskIntoConstraints = false
        blurContainerView.translatesAutoresizingMaskIntoConstraints = false
        ratingIconView.translatesAutoresizingMaskIntoConstraints = false
        ratingTextView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        genresCollection.translatesAutoresizingMaskIntoConstraints = false
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Containers
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            // Poster
            posterViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterViewContainer.heightAnchor.constraint(equalToConstant: 420),
            posterViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizes.System.large),
            posterViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Sizes.System.large),
            
            blurContainerView.contentView.leadingAnchor.constraint(equalTo: posterViewContainer.leadingAnchor,
                                                                   constant: Sizes.System.medium),
            blurContainerView.contentView.bottomAnchor.constraint(equalTo: posterViewContainer.bottomAnchor,
                                                                  constant: -Sizes.System.medium),
            blurContainerView.contentView.heightAnchor.constraint(equalToConstant: 42),
            blurContainerView.contentView.widthAnchor.constraint(equalToConstant: 80),
            
            ratingIconView.centerYAnchor.constraint(equalTo: blurContainerView.contentView.centerYAnchor),
            ratingIconView.leadingAnchor.constraint(equalTo: blurContainerView.contentView.leadingAnchor, constant: 12),
            
            ratingTextView.centerYAnchor.constraint(equalTo: blurContainerView.contentView.centerYAnchor),
            ratingTextView.leadingAnchor.constraint(equalTo: ratingIconView.trailingAnchor, constant: Sizes.System.small),
            // Text
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizes.System.large),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Sizes.System.large),
            titleView.topAnchor.constraint(equalTo: posterViewContainer.bottomAnchor, constant: Sizes.System.large),
            
            genresCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizes.System.large),
            genresCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Sizes.System.large),
            genresCollection.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Sizes.System.small),
            
            overviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizes.System.large),
            overviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Sizes.System.large),
            overviewView.topAnchor.constraint(equalTo: genresCollection.bottomAnchor, constant: Sizes.System.small),
            overviewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Sizes.System.large)
        ])
    }
    
    deinit {
        // TODO: Cancel image fetch on exit screen
        imageLoadTask.forEach { $0.cancel() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
