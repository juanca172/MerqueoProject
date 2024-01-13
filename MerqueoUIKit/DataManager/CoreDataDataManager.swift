//
//  CoreDataDataManager.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 9/01/24.
//

import Foundation
protocol CoreDataDataManagerProtocol {
    func saveMovie(movie: Info, cast: String, director: String, year: String)
}
class CoreDataDataManager: CoreDataDataManagerProtocol {
    let coreDataStack: CoreDataStackProtocol?
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    func saveMovie(movie: Info, cast: String, director: String, year: String) {
        guard let context = coreDataStack?.managedContext else { return }
        let movieEntity = MovieCoreData(context: context)
        movieEntity.movieCast = cast
        movieEntity.movieDescription = movie.overview
        movieEntity.movieDirector = director
        movieEntity.movieImage = movie.backdropPath
        movieEntity.movieTitle = movie.originalTitle
        movieEntity.movieYear = year
        coreDataStack?.save()
    }
}
