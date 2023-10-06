//
//  MoviesTableViewController.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 28/09/23.
//

import UIKit
import Combine

final class MoviesTableViewController: UITableViewController, Coordinating {
    
    private var cancellables = Set<AnyCancellable>()
    private var isDownloadingData = false
    
    var viewModel: MoviesViewModel! {
        didSet {
            viewModel.$popularMoviesList
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in self?.handleUpdates() }
                .store(in: &cancellables)
        }
    }
    
    var posterImageRepository: PosterImageRepositoryType!
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func handleUpdates() {
        reload()
        // Removingo loading footer
        isDownloadingData = false
        tableView.tableFooterView = nil
    }
    
    func updateLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: CGSize(width: 36, height: 42))
        tableView.tableFooterView = activityIndicator
    }
    
    private func reload() {
        tableView.reloadData()
    }
    
    private func setupViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Sizes.Components.movieCell.height
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dragInteractionEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
    }
}

// MARK: - Table view data source
extension MoviesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.popularMoviesList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.Components.movieCell.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier)
        as? MovieTableViewCell ?? MovieTableViewCell(
            style: .default,
            reuseIdentifier: MovieTableViewCell.identifier)
        
        if indexPath.row == viewModel.popularMoviesList.count - 1 &&
            !isDownloadingData &&
            viewModel.currentPage + 1 <= viewModel.maxPage
        {
            updateLoading()
            viewModel.loadNextPage()
        }
        
        cell.config(with: viewModel.popularMoviesList[indexPath.row],
                    posterImageRepository: posterImageRepository)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.sendScreenEvent(with: .movieTapped(viewModel.popularMoviesList[indexPath.row]))
    }
}
