//
//  Movie.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

struct Movie {
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String
    let genres: [Genre]
    let runtime: Int?
    let cast: [Actor]
    let images: [MovieImage]

    struct Genre {
        
        let id: Int
        let name: String
        
    }

    struct MovieImage {
        
        let filePath: String
        
    }
    
}
