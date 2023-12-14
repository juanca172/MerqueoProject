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
    var backdropPath: String?
    var genreIds: [Int]
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var popularity: Double
    var posterPath: String
    var releaseDate: Date
    var title: String
    var video: Bool
    var voteAverage: Double
    var voteCount: Int
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
extension Info {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        adult = try container.decode(Bool.self, forKey: .adult)
        backdropPath = try container.decode(String?.self, forKey: .backdropPath)
        genreIds = try container.decode([Int].self, forKey: .genreIds)
        id = try container.decode(Int.self, forKey: .id)
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        overview = try container.decode(String.self, forKey: .overview)
        popularity = try container.decode(Double.self, forKey: .popularity)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        title = try container.decode(String.self, forKey: .title)
        video = try container.decode(Bool.self, forKey: .video)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
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
