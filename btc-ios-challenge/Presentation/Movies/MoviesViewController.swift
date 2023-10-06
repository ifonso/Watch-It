//
//  MoviesViewController.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import UIKit

final class MoviesViewController: UIViewController, Coordinating {
    
    private var viewModel: MoviesViewModel!
    private var posterImageRepository: PosterImageRepositoryType!
    
    private var moviesTableViewController: MoviesTableViewController!
    private var tableView: UIView!
    
    var coordinator: Coordinator?
    
    // MARK: Factory
    static func create(with viewModel: MoviesViewModel,
                       posterImageRepository: PosterImageRepositoryType,
                       coordinator: Coordinator?
    ) -> MoviesViewController {
        let controller = MoviesViewController()
        controller.viewModel = viewModel
        controller.coordinator = coordinator
        controller.posterImageRepository = posterImageRepository
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupTable()
        setupNavigationTitle()
        setupConstraints()
        setupView()
    }
    
    private func setupTable() {
        moviesTableViewController = MoviesTableViewController()
        moviesTableViewController.viewModel = viewModel
        moviesTableViewController.posterImageRepository = posterImageRepository
        moviesTableViewController.coordinator = coordinator
        tableView = moviesTableViewController.view
        add(moviesTableViewController)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationTitle() {
        title = "Filmes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
