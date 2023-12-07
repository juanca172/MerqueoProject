//
//  MovieDataManager.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 7/12/23.
//

import Foundation

protocol MovieDataManagerProtocol {
    func getDataFromMoview<T:Decodable>() async -> T
}
struct MovieDataManager {
    let networkProvider: NetworkProviderProtocol
    init(networkProvider: NetworkProviderProtocol = NetworkProvider()) {
        self.networkProvider = networkProvider
    }
}
extension MovieDataManager: MovieDataManagerProtocol {
    func getDataFromMoview <T:Decodable>() async -> T {
        let urlRequest = URLRequest(url: URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=1e8867b1626434a57994c431d6d77ef9&sort_by=popularity.desc")!)
        return try! await networkProvider.fetcher(request: urlRequest)
    }
}
