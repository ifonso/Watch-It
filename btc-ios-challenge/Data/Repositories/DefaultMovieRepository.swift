//
//  DefaultMovieRepository.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 10/10/23.
//

import Foundation
import CoreData

enum LocalStorageErrors: Error {
    case saveError
    case deletionError
    case fetchError
    case unknown
}

final class DefaultMovieRepository: LocalMovieRepositoryType {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "MovieModel")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("[CoreData]: Error loading Core Data: \(error!.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    func findAll() throws -> [MovieDetailsResponse] {
        let result = getEntities()
        switch result {
        case .success(let movies):
            return movies.compactMap { movie in
                guard let title = movie.title,
                      let genres = movie.genres,
                      let synopsis = movie.synopsis,
                      let poster = movie.poster,
                      let rating = movie.rating,
                      let year = movie.year
                else { return nil }
                
                return MovieDetailsResponse(
                    id: Int(movie.id),
                    title: title,
                    genres: genres.map { .init(name: $0) },
                    overview: synopsis,
                    poster: poster,
                    rating: Double.parseRating(rating),
                    year: year
                )
            }

        case .failure(let error):
            throw error
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        let result = getEntityBy(id: id)
        
        switch result {
        case .success(let movie):
            return movie != nil
        case .failure(_):
            return false
        }
    }
    
    func save(movie data: MovieDetailsResponse) throws {
        let movie = Movie(context: context)
        movie.id = Int64(data.id)
        movie.title = data.title
        movie.synopsis = data.overview
        movie.genres = data.genres.map { $0.name }
        movie.rating = Double.ratingFormat(data.rating)
        movie.poster = data.poster
        movie.year = data.year
        
        guard self.save() else {
            throw LocalStorageErrors.saveError
        }
    }
    
    func delete(id: Int) throws {
        let result = getEntityBy(id: id)
        
        if case .failure(let error) = result {
            throw error
        }
        
        if case .success(let movieToDelete) = result {
            guard let movie = movieToDelete else { return }
            context.delete(movie)
        }
        
        guard self.save() else {
            throw LocalStorageErrors.deletionError
        }
    }
    
    // MARK: - Core Data Utility
    private func getEntityBy(id: Int) -> Result<Movie?, LocalStorageErrors> {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            guard let movie = try context.fetch(request).first else {
                return .success(nil)
            }
            return .success(movie)
        } catch {
            NSLog("[CoreData Fetch Error]: \(error.localizedDescription)")
            return .failure(.fetchError)
        }
    }
    
    private func getEntities() -> Result<[Movie], LocalStorageErrors> {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            return .success(try context.fetch(request))
        } catch {
            NSLog("[CoreData Fetch Error]: \(error.localizedDescription)")
            return .failure(.fetchError)
        }
    }
    
    private func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            NSLog("[CoreData Save Error]: \(error.localizedDescription)")
            return false
        }
    }
}
