//
//  Networking.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 5/12/23.
//

import Foundation

protocol NetworkProviderProtocol {
    func fetcher<T: Decodable> (request: URLRequest) async throws -> T
}

enum NetworkError: Error, Equatable {
    case decodingError
    case networkError
    case statusCodeError
}
extension NetworkError {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError):
            return true
        case (.networkError, .networkError):
            return true
        case (.statusCodeError, .statusCodeError):
            return true
        default:
            return false
        }
    }
}

struct NetworkProvider: NetworkProviderProtocol {
    
    let jsonDecoder: JSONDecoder
    let urlSession: URLSession
    
    init(jsonDecoder: JSONDecoder = JSONDecoder(),urlSession: URLSession = URLSession.shared) {
        self.jsonDecoder = jsonDecoder
        self.urlSession = urlSession
    }
    
    func fetcher<T: Decodable>(request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 204 || response.statusCode >= 500 && response.statusCode <= 599 else {
                throw NetworkError.statusCodeError
            }
            if response.statusCode >= 500 && response.statusCode <= 599 {
                throw NetworkError.networkError
            }
            let success = try jsonDecoder.decode(T.self, from: data)
            return success
        } catch let _ as DecodingError {
            throw NetworkError.decodingError
        }
    }
    
    
}