//
//  MovieDataManager.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 7/12/23.
//

import Foundation

protocol MovieDataManagerProtocol {
    func getDataFromMoview(pageToFectch: Int) async throws -> MovieModel
    func getDataFromCredits(idToFetch: Int) async throws -> CreditsModel
}
struct MovieDataManager {
    let networkProvider: NetworkProviderProtocol
    init(networkProvider: NetworkProviderProtocol = NetworkProvider()) {
        self.networkProvider = networkProvider
    }
}
extension MovieDataManager: MovieDataManagerProtocol {
    func getDataFromCredits(idToFetch: Int) async throws -> CreditsModel {
        let request = MovieResourceRoutes.credistPath(MoviewID: idToFetch).urlRequestComplete
        return try await networkProvider.fetcher(request: request)
    }
    func getDataFromMoview(pageToFectch: Int) async throws -> MovieModel {
        let urlRequest = MovieResourceRoutes.pageRoute(page: pageToFectch).urlRequestComplete
        return try await networkProvider.fetcher(request: urlRequest)
    }
}
