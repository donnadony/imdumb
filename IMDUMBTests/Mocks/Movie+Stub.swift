//
//  Movie+Stub.swift
//  IMDUMBTests
//
//  Created by Donnadony Mollo on 7/05/26.
//

@testable import IMDUMB

extension Movie {

    static func stub(
        id: Int = 1,
        title: String = "Test Movie",
        overview: String = "Test overview",
        posterPath: String? = "/poster.jpg",
        backdropPath: String? = "/backdrop.jpg",
        voteAverage: Double = 7.5,
        releaseDate: String = "2026-01-15",
        genres: [Movie.Genre] = [Movie.Genre(id: 28, name: "Action")],
        runtime: Int? = 120,
        cast: [Actor] = [Actor(id: 1, name: "John Doe", character: "Hero", profilePath: "/profile.jpg")],
        images: [Movie.MovieImage] = [Movie.MovieImage(filePath: "/image.jpg")]
    ) -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            releaseDate: releaseDate,
            genres: genres,
            runtime: runtime,
            cast: cast,
            images: images
        )
    }
}
