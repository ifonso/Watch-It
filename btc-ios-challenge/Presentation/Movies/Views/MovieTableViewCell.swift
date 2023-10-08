//
//  MovieTableViewCell.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import UIKit
import Combine

final class MovieTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: MovieTableViewCell.self)
    
    private var viewModel: MovieListItemDTO!
    private var posterImageRepository: PosterImageRepositoryType?
    private var imageLoadTask = Set<AnyCancellable>() {
        willSet { imageLoadTask.forEach({ $0.cancel() }) }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "Movie Title"
        return label
    }()
    
    private lazy var yearView: UILabel = {
        let label = UILabel()
        label.text = "2023"
        return label
    }()
    
    private lazy var posterView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViewHierarchy()
        setupConstraints()
    }
    
    func config(with data: MovieResponse,
                posterImageRepository: PosterImageRepositoryType
    ) {
        let viewModel = MovieListItemDTO(movie: data)
        
        self.viewModel = viewModel
        self.posterImageRepository = posterImageRepository
        
        posterView.image = nil
        titleView.text = viewModel.title
        yearView.text = viewModel.year
        setupPoster(url: data.getPosterUrlString(size: .medium))
    }
    
    private func setupPoster(url: String) {
        Task { @MainActor [weak self] in
            self?.posterView.image = await self?.posterImageRepository?.loadImage(from: url)
        }
        .store(in: &imageLoadTask)
    }
    
    private func setupViewHierarchy() {
        containerView.addSubview(titleView)
        containerView.addSubview(yearView)
        containerView.addSubview(posterView)
        backgroundView = containerView
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        yearView.translatesAutoresizingMaskIntoConstraints = false
        posterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Container
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            // Poster
            posterView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Sizes.System.large),
            posterView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            posterView.heightAnchor.constraint(equalToConstant: Sizes.Components.poster.height),
            posterView.widthAnchor.constraint(equalToConstant: Sizes.Components.poster.width),
            // Title
            titleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 47),
            titleView.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: Sizes.System.medium),
            // Year
            yearView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Sizes.System.small),
            yearView.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: Sizes.System.medium)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
