//
//  FavoritosViewController.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import UIKit

final class FavoritesViewController: UIViewController, Coordinating {
    
    private var viewModel: FavoritesViewModel!
    private var posterImageRepository: PosterImageRepositoryType!
    
    private var favoritesTableViewController: FavoritesTableViewController!
    private var tableView: UIView!
    
    var coordinator: Coordinator?
    
    // MARK: Factory
    static func create(with viewModel: FavoritesViewModel,
                       posterImageRepository: PosterImageRepositoryType,
                       coordinator: Coordinator?
    ) -> FavoritesViewController {
        let controller = FavoritesViewController()
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
        favoritesTableViewController = FavoritesTableViewController()
        favoritesTableViewController.viewModel = viewModel
        favoritesTableViewController.posterImageRepository = posterImageRepository
        favoritesTableViewController.coordinator = coordinator
        tableView = favoritesTableViewController.view
        add(favoritesTableViewController)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationTitle() {
        title = "Favoritos"
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
