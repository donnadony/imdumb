//
//  MovieDTO.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

struct MovieDTO: Decodable {
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        
    }
    
}

struct MovieListDTO: Decodable {
    
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        
    }
    
}
