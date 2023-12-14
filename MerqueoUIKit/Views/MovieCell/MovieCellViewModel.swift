//
//  MovieCellViewModel.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 11/12/23.
//

import Foundation

protocol MoviewCellViewModelProtocol {
    
}

final class MovieCellViewModel: MoviewCellViewModelProtocol {
    var info: Info
    init(info: Info) {
        self.info = info
    }
    var title: String {
        info.title
    }
    var image: URL? {
        return MovieResourceRoutes.posterPath(value: info.posterPath).finalURL
        return nil
    }
}
