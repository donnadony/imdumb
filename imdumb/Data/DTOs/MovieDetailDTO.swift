//
//  MovieDetailDTO.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

struct MovieDetailDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let runtime: Int?
    let genres: [GenreDTO]?
    let credits: CreditsDTO?
    let images: ImagesDTO?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, credits, images
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

struct CreditsDTO: Decodable {
    let cast: [CastDTO]?
}

struct CastDTO: Decodable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}

struct ImagesDTO: Decodable {
    let backdrops: [BackdropDTO]?
}

struct BackdropDTO: Decodable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}
