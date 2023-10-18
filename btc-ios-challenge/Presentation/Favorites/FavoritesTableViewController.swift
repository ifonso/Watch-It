//
//  FavoritesTableViewController.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 13/10/23.
//

import UIKit
import Combine

final class FavoritesTableViewController: UITableViewController, Coordinating {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: FavoritesViewModel! {
        didSet {
            viewModel.$movies
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in self?.reload() }
                .store(in: &cancellables)
        }
    }
    
    var posterImageRepository: PosterImageRepositoryType!
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad()
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
extension FavoritesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.Components.movieCell.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier)
        as? MovieTableViewCell ?? MovieTableViewCell(
            style: .default,
            reuseIdentifier: MovieTableViewCell.identifier)
        
        // TODO: Fix data model
        let movie = viewModel.movies[indexPath.row]
        let data = MovieResponse(id: movie.id, title: movie.title, year: "2001", poster: movie.poster)
        
        cell.config(with: data, posterImageRepository: posterImageRepository)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

