//
//  MovieMapperTests.swift
//  IMDUMBTests
//
//  Created by Donnadony Mollo on 7/05/26.
//

import XCTest
@testable import IMDUMB

final class MovieMapperTests: XCTestCase {

    func test_toDomain_fromMovieDTO_mapsBasicFields() {
        let dto = MovieDTO(
            id: 10,
            title: "Matrix",
            overview: "A movie about the matrix",
            posterPath: "/matrix.jpg",
            backdropPath: "/matrix_bg.jpg",
            voteAverage: 8.7,
            releaseDate: "1999-03-31"
        )

        let movie = MovieMapper.toDomain(dto)

        XCTAssertEqual(movie.id, 10)
        XCTAssertEqual(movie.title, "Matrix")
        XCTAssertEqual(movie.overview, "A movie about the matrix")
        XCTAssertEqual(movie.posterPath, "/matrix.jpg")
        XCTAssertEqual(movie.voteAverage, 8.7)
        XCTAssertEqual(movie.releaseDate, "1999-03-31")
        XCTAssertTrue(movie.genres.isEmpty)
        XCTAssertTrue(movie.cast.isEmpty)
        XCTAssertTrue(movie.images.isEmpty)
        XCTAssertNil(movie.runtime)
    }

    func test_toDomain_fromMovieDTO_handlesNilReleaseDate() {
        let dto = MovieDTO(
            id: 1,
            title: "No Date",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            voteAverage: 0,
            releaseDate: nil
        )

        let movie = MovieMapper.toDomain(dto)

        XCTAssertEqual(movie.releaseDate, "")
    }

    func test_toDomain_fromDetailDTO_mapsAllFields() {
        let genreDTO = GenreDTO(id: 28, name: "Action")
        let castDTO = CastDTO(id: 1, name: "Keanu", character: "Neo", profilePath: "/keanu.jpg")
        let backdropDTO = BackdropDTO(filePath: "/bg1.jpg")
        let dto = MovieDetailDTO(
            id: 20,
            title: "Matrix Reloaded",
            overview: "Sequel",
            posterPath: "/poster2.jpg",
            backdropPath: "/bg2.jpg",
            voteAverage: 7.2,
            releaseDate: "2003-05-15",
            runtime: 138,
            genres: [genreDTO],
            credits: CreditsDTO(cast: [castDTO]),
            images: ImagesDTO(backdrops: [backdropDTO])
        )

        let movie = MovieMapper.toDomain(dto)

        XCTAssertEqual(movie.id, 20)
        XCTAssertEqual(movie.title, "Matrix Reloaded")
        XCTAssertEqual(movie.runtime, 138)
        XCTAssertEqual(movie.genres.count, 1)
        XCTAssertEqual(movie.genres.first?.name, "Action")
        XCTAssertEqual(movie.cast.count, 1)
        XCTAssertEqual(movie.cast.first?.name, "Keanu")
        XCTAssertEqual(movie.cast.first?.character, "Neo")
        XCTAssertEqual(movie.images.count, 1)
        XCTAssertEqual(movie.images.first?.filePath, "/bg1.jpg")
    }

    func test_toDomain_fromDetailDTO_limitsCastTo10() {
        let castDTOs = (0..<15).map { i in
            CastDTO(id: i, name: "Actor \(i)", character: "Char \(i)", profilePath: nil)
        }
        let dto = MovieDetailDTO(
            id: 1,
            title: "Big Cast",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            voteAverage: 5.0,
            releaseDate: "2026-01-01",
            runtime: nil,
            genres: nil,
            credits: CreditsDTO(cast: castDTOs),
            images: nil
        )

        let movie = MovieMapper.toDomain(dto)

        XCTAssertEqual(movie.cast.count, 10)
    }
}
