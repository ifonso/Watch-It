//
//  MovieDetailsViewController.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 07/10/23.
//

import UIKit
import Combine

final class MovieDetailsViewController: UIViewController {
    
    private var detailsView: MovieDetailsView!
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: MovieDetailsViewModel!
    var posterImageRepository: PosterImageRepositoryType!
    
    // MARK: Factory
    static func create(with viewModel: MovieDetailsViewModel,
                       posterImageRepository: PosterImageRepositoryType
    ) -> MovieDetailsViewController {
        let controller = MovieDetailsViewController()
        controller.viewModel = viewModel
        controller.posterImageRepository = posterImageRepository
        return controller
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDataBinding()
        viewModel.viewDidLoad()
    }
    
    private func setupDataBinding() {
        viewModel.$movieData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in self?.didUpdateData() }
            .store(in: &cancellables)
    }
    
    private func didUpdateData() {
        guard let movie = viewModel.movieData else { return }
        let movieDetails = MovieDetailsDTO(posterImageUrlString: movie.getPosterUrlString(size: .large),
                                           rating: movie.rating,
                                           title: movie.title,
                                           overview: movie.overview)
        detailsView.config(movie: movieDetails,
                           posterImageRepository: posterImageRepository)
        detailsView.genresCollection.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupView() {
        detailsView = MovieDetailsView()
        detailsView.genresCollection.delegate = self
        detailsView.genresCollection.dataSource = self
        view = detailsView
    }
}

extension MovieDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieData?.genres.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath)
        as? GenreCollectionViewCell ?? GenreCollectionViewCell()
        cell.setGenreName(name: viewModel.movieData?.genres[indexPath.row].name ?? "")
        return cell
    }
}
