//
//  ViewDetailMovieViewModel.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 12/12/23.
//

import Foundation

protocol ViewDetailMovieViewModelProtocol {
    //func setUp(movie: MovieModel)
    func getCreditsData() async
}

final class ViewDetailMovieViewModel: ViewDetailMovieViewModelProtocol, ObservableObject {
    var info: Info
    var dataManager: MovieDataManagerProtocol
    private var castNames: String = ""
    private var directorData: [CrewModel] = []
    @Published var cast: String?
    @Published var director: String?
    init(info: Info, dataManager: MovieDataManagerProtocol = MovieDataManager()) {
        self.info = info
        self.dataManager = dataManager
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
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return info.releaseDate.formatted(.dateTime.year())
    }

    func getCreditsData() async {
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
                await MainActor.run {
                    cast = arrayNames.joined(separator: ",")
                    director = directorData.first?.name ?? "No found"
                }
            } catch {
                print(error)
            }
        }
    }
}
