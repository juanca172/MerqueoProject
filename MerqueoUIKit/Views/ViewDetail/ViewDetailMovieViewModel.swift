//
//  ViewDetailMovieViewModel.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 12/12/23.
//

import Foundation

protocol ViewDetailMovieViewModelProtocol {
    //func setUp(movie: MovieModel)
}

final class ViewDetailMovieViewModel: ViewDetailMovieViewModelProtocol {
    var info: Info
    init(info: Info) {
        self.info = info
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
    
}
