//
//  MovieDetailsViewModel.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 08/10/23.
//

import Foundation
import Combine

final class MovieDetailsViewModel {
    
    @Published private(set) var movieData: MovieDetailsResponse?
    
    private var cancellables = Set<AnyCancellable>()
    private var error: Error?
    
    private let movieDetailsUseCase: GetMovieDetailsUseCaseType
    private let moiveInfo: MovieResponse
    
    init(movie: MovieResponse, movieDetailsUseCase: GetMovieDetailsUseCaseType) {
        self.movieDetailsUseCase = movieDetailsUseCase
        self.moiveInfo = movie
    }
    
    func viewDidLoad() {
        fetchAndUpdateMovieFor(id: moiveInfo.id)
    }
    
    private func fetchAndUpdateMovieFor(id: Int) {
        Task { @MainActor [weak self] in
            guard let result = await self?.movieDetailsUseCase.execute(id: id) else { return }
            
            switch result {
            case .success(let data):
                self?.movieData = data
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
}
