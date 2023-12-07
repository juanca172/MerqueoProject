//
//  ImageRoute.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 6/12/23.
//

import Foundation

protocol ImageRouteCompleteProtocol {
    var finalURL: URL? { get }
    var urlRequestComplete: URLRequest { get }
}
enum ImageRoute: ImageRouteCompleteProtocol {
    case backDropPath(value: String)
}
extension ImageRoute {
    var finalURL: URL? {
        var urlComponents = URLComponents(string: "https://image.tmdb.org")
        switch self {
        case .backDropPath(value: let value):
            urlComponents?.path = "/t/p/w200\(value)"
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
