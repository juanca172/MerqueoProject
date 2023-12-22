//
//  ImageRoute.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 6/12/23.
//

import Foundation
import UIKit

protocol ImageRouteCompleteProtocol {
    var finalURL: URL? { get }
    var urlRequestComplete: URLRequest { get }
}
enum MovieResourceRoutes: ImageRouteCompleteProtocol {
    case posterPath(value: String)
    case pageRoute(page: Int)
    case credistPath(MoviewID: Int)
}
extension MovieResourceRoutes {
    var finalURL: URL? {
        switch self {
        case .posterPath(value: let value):
            var urlComponents = URLComponents(string: "https://image.tmdb.org")
            urlComponents?.path = "/t/p/w300\(value)"
            return urlComponents?.url?.absoluteURL
        case.pageRoute(page: let pageNumber):
            if pageNumber <= 500 {
                var urlComponents = URLComponents(string: "https://api.themoviedb.org")
                urlComponents?.path = "/3/discover/movie"
                let apiKey = URLQueryItem(name: "api_key", value: "1e8867b1626434a57994c431d6d77ef9")
                let queryItems = URLQueryItem(name: "page", value: String(pageNumber))
                let sortQuery = URLQueryItem(name: "sort_by", value: "popularity.desc")
                urlComponents?.queryItems = [apiKey, sortQuery, queryItems]
                return urlComponents?.url?.absoluteURL
            } else {
                assert(false, "El valor tiene que ser menor de 500")
            }
        case .credistPath(MoviewID: let id):
            var urlComponents = URLComponents(string: "https://api.themoviedb.org")
            urlComponents?.path = "/3/movie/\(id)/credits"
            let apiKey = URLQueryItem(name: "api_key", value: "1e8867b1626434a57994c431d6d77ef9")
            urlComponents?.queryItems = [apiKey]
            return urlComponents?.url?.absoluteURL
        }
    }
    var urlRequestComplete: URLRequest {
        guard let url = finalURL else {
            assert(false, "Error in URL")
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}
