//
//  ViewDetailMovieViewModel.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 12/12/23.
//

import Foundation

protocol ViewDetailMovieViewModelProtocol {
    //func setUp(movie: MovieModel)
    func getCreditsData()
}

final class ViewDetailMovieViewModel: ViewDetailMovieViewModelProtocol {
    var info: Info
    var dataManager: MovieDataManagerProtocol
    private var castNames: String = ""
    private var directorData: [CrewModel] = []
    init(info: Info, dataManager: MovieDataManagerProtocol = MovieDataManager()) {
        self.info = info
        self.dataManager = dataManager
        self.getCreditsData()
    }
    var title: String {
        info.title
    }
    var image: URL? {
        return MovieResourceRoutes.posterPath(value: info.posterPath).finalURL
    }
    var descripcion: String {
        info.overview
    }
    var cast: String {
        castNames
    }
    var director: String {
        directorData.first?.name ?? "no found"
    }
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return info.releaseDate.formatted(.dateTime.year())
    }

    func getCreditsData() {
        Task {
            do {
                let data: CreditsModel = try await dataManager.getDataFromCredits(idToFetch: info.id)
                directorData = data.crew.filter({ value in
                    if value.job == "Director" {
                        true
                    } else {
                        false
                    }
                })
                let arrayNames = data.cast.map({ $0.name })
                castNames = arrayNames.joined(separator: ",")
                print(castNames)
            } catch {
                print(error)
            }
        }
    }
}
