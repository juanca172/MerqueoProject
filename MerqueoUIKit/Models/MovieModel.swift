//
//  MovieModel.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 5/12/23.
//

import Foundation

struct MovieModel: Codable {
    var page: Int
    var results: [Info]
    var totalPages: Int
    var totalResults: Int
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Info: Codable, Hashable {
    var adult: Bool
    var backdropPath: String
    var genreIds: [Int]
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var popularity: Double
    var posterPath: String
    var releaseDate: String
    var title: String
    var video: Bool
    var voteAverage: Double
    var voteCount: Int
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case adult
        case id
        case overview
        case popularity
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
extension Info {
    static func ==(lhs: Info, rhs: Info) -> Bool {
        return lhs.id == rhs.id  
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
