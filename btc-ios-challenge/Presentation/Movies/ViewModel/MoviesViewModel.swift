//
//  MoviesViewModel.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 28/09/23.
//

import Foundation
import Combine

final class MoviesViewModel {
    
    @Published private(set) var popularMoviesList: [MovieResponse] = []
    @Published private(set) var currentPage: Int = 0
    @Published private(set) var maxPage: Int = 0
    @Published private(set) var error: Error? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let popularMoviesUseCase: GetPopularMoviesUseCaseType
    
    init(popularMoviesUseCase: GetPopularMoviesUseCaseType) {
        self.popularMoviesUseCase = popularMoviesUseCase
    }
    
    func loadNextPage() {
        guard currentPage + 1 <= maxPage else { return }
        currentPage += 1
        fetchAndAppendMoviesFrom(page: currentPage)
    }
    
    func viewDidLoad() {
        currentPage = 1
        fetchAndAppendMoviesFrom(page: currentPage)
    }
    
    private func fetchAndAppendMoviesFrom(page: Int) {
        Task { @MainActor [weak self] in
            guard let result = await self?.popularMoviesUseCase.execute(page: page) else { return }
            
            switch result {
            case .success(let data):
                self?.popularMoviesList.append(contentsOf: data.movies)
                self?.maxPage = data.pages
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
}
