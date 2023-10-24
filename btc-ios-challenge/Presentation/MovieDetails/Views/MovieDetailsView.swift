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
    
    // MARK: Loading
    private lazy var loadingView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: CGSize(width: 56, height: 56))
        activityIndicator.layer.zPosition = 100
        return activityIndicator
    }()
    
    // MARK: Poster content
    private lazy var posterViewContainer: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var ratingBlurContainerView: UIVisualEffectView = {
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
    
    private lazy var saveBlurContainerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        var effectsView = UIVisualEffectView(effect: blurEffect)
        effectsView.clipsToBounds = true
        effectsView.layer.cornerRadius = 14
        return effectsView
    }()
    
    private lazy var saveButtonView: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.alpha = 1.0
        return button
    }()
    
    // MARK: Text Content
    private lazy var titleView: UILabel = {
        var label = UILabel()
        // Custom Text
        label.numberOfLines = 0
        label.font = UIFont.movieBigTitle
        label.textColor = .primaryText
        return label
    }()
    
    private lazy var overviewView: UILabel = {
        var label = UILabel()
        // Custom Text
        label.numberOfLines = 0
        label.font = UIFont.overviewText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setSaveButtonAction(target: Any, action: Selector) {
        saveButtonView.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func changeSaveButtonIcon(isFavorite: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .medium)
        if isFavorite {
            let image = UIImage(systemName: "xmark", withConfiguration: config)
            saveButtonView.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "plus", withConfiguration: config)
            saveButtonView.setImage(image, for: .normal)
        }
    }
    
    func config(movie: MovieDetailsDTO,
                posterImageRepository: PosterImageRepositoryType
    ) {
        self.posterImageRepository = posterImageRepository
        
        titleView.text = movie.title
        titleView.setLineSpacing(with: 3)
        
        overviewView.text = movie.overview
        overviewView.setLineSpacing(with: 2)
        
        ratingTextView.text = Double.ratingFormat(movie.rating)
        setupPoster(url: movie.posterImageUrlString)
        
        // Fade in
        self.loadingView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.contentView.alpha = 1
        }
    }
    
    private func setupPoster(url: String) {
        Task { @MainActor [weak self] in
            defer {
                UIView.animate(withDuration: 1) {
                    self?.posterViewContainer.alpha = 1
                }
            }
            guard let image = await self?.posterImageRepository?.loadImage(from: url)
            else { return }
            self?.posterViewContainer.image = image
        }
        .store(in: &imageLoadTask)
    }
    
    private func setupViews() {
        backgroundColor = .backgroud
        ratingBlurContainerView.contentView.addSubview(ratingIconView)
        ratingBlurContainerView.contentView.addSubview(ratingTextView)
        saveBlurContainerView.contentView.addSubview(saveButtonView)
        saveButtonView.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        posterViewContainer.addSubview(ratingBlurContainerView)
        posterViewContainer.addSubview(saveBlurContainerView)
        // Containers
        contentView.addSubview(posterViewContainer)
        contentView.addSubview(titleView)
        contentView.addSubview(genresCollection)
        contentView.addSubview(overviewView)
        scrollView.addSubview(contentView)
        addSubview(scrollView)
        addSubview(loadingView)
        
        // Alpha for transition
        posterViewContainer.alpha = 0
        contentView.alpha = 0
    }
    
    @objc
    private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.saveButtonView.alpha = 0.1
            
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.saveButtonView.alpha = 1
            }
        }
    }
    
    private func setupConstraints() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        posterViewContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingBlurContainerView.translatesAutoresizingMaskIntoConstraints = false
        ratingIconView.translatesAutoresizingMaskIntoConstraints = false
        ratingTextView.translatesAutoresizingMaskIntoConstraints = false
        saveBlurContainerView.translatesAutoresizingMaskIntoConstraints = false
        saveButtonView.translatesAutoresizingMaskIntoConstraints = false
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
            
            ratingBlurContainerView.contentView.leadingAnchor.constraint(equalTo: posterViewContainer.leadingAnchor,
                                                                         constant: Sizes.System.medium),
            ratingBlurContainerView.contentView.bottomAnchor.constraint(equalTo: posterViewContainer.bottomAnchor,
                                                                        constant: -Sizes.System.medium),
            ratingBlurContainerView.contentView.heightAnchor.constraint(equalToConstant: Sizes.Components.movieRatingLabel.height),
            ratingBlurContainerView.contentView.widthAnchor.constraint(equalToConstant: Sizes.Components.movieRatingLabel.width),
            
            ratingIconView.centerYAnchor.constraint(equalTo: ratingBlurContainerView.contentView.centerYAnchor),
            ratingIconView.leadingAnchor.constraint(equalTo: ratingBlurContainerView.contentView.leadingAnchor, constant: 12),
            
            ratingTextView.centerYAnchor.constraint(equalTo: ratingBlurContainerView.contentView.centerYAnchor),
            ratingTextView.leadingAnchor.constraint(equalTo: ratingIconView.trailingAnchor, constant: Sizes.System.small),
            
            saveBlurContainerView.contentView.trailingAnchor.constraint(equalTo: posterViewContainer.trailingAnchor,
                                                                        constant: -Sizes.System.medium),
            saveBlurContainerView.contentView.bottomAnchor.constraint(equalTo: posterViewContainer.bottomAnchor,
                                                                      constant: -Sizes.System.medium),
            saveBlurContainerView.contentView.heightAnchor.constraint(equalToConstant: Sizes.Components.saveMovieButton.height),
            saveBlurContainerView.contentView.widthAnchor.constraint(equalToConstant: Sizes.Components.saveMovieButton.width),
            
            saveButtonView.centerXAnchor.constraint(equalTo: saveBlurContainerView.centerXAnchor),
            saveButtonView.centerYAnchor.constraint(equalTo: saveBlurContainerView.centerYAnchor),
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
            overviewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Sizes.System.large),
            
            // Loading
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor)
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
