//
//  MockMovieRepository.swift
//  IMDUMBTests
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation
@testable import IMDUMB

final class MockMovieRepository: MovieRepositoryProtocol {

    var fetchGenresResult: Result<[IMDUMB.Category], Error> = .success([])
    var fetchMoviesByGenreResult: Result<[Movie], Error> = .success([])
    var fetchMovieDetailResult: Result<Movie, Error> = .success(Movie.stub())

    var fetchGenresCallCount = 0
    var fetchMoviesByGenreCallCount = 0
    var fetchMovieDetailCallCount = 0
    var lastFetchedMovieId: Int?
    var lastFetchedGenreId: Int?

    func fetchGenres(completion: @escaping (Result<[IMDUMB.Category], Error>) -> Void) {
        fetchGenresCallCount += 1
        completion(fetchGenresResult)
    }

    func fetchMoviesByGenre(genreId: Int, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        fetchMoviesByGenreCallCount += 1
        lastFetchedGenreId = genreId
        completion(fetchMoviesByGenreResult)
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        fetchMovieDetailCallCount += 1
        lastFetchedMovieId = movieId
        completion(fetchMovieDetailResult)
    }

    func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        completion(.success([]))
    }
}

final class MockFavoriteRepository: FavoriteRepositoryProtocol {

    var fetchAllResult: Result<[FavoriteMovie], Error> = .success([])
    var addResult: Result<Void, Error> = .success(())
    var removeResult: Result<Void, Error> = .success(())
    var isFavoriteResult: Result<Bool, Error> = .success(false)

    func fetchAll(completion: @escaping (Result<[FavoriteMovie], Error>) -> Void) {
        completion(fetchAllResult)
    }

    func add(_ movie: FavoriteMovie, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(addResult)
    }

    func remove(movieId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(removeResult)
    }

    func isFavorite(movieId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(isFavoriteResult)
    }
}

final class MockRecommendationRepository: RecommendationRepositoryProtocol {

    var saveResult: Result<Void, Error> = .success(())
    var fetchForMovieResult: Result<[Recommendation], Error> = .success([])
    var fetchRecommendedMovieIdsResult: Result<Set<Int>, Error> = .success([])

    func save(_ recommendation: Recommendation, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(saveResult)
    }

    func fetchForMovie(movieId: Int, completion: @escaping (Result<[Recommendation], Error>) -> Void) {
        completion(fetchForMovieResult)
    }

    func fetchRecommendedMovieIds(completion: @escaping (Result<Set<Int>, Error>) -> Void) {
        completion(fetchRecommendedMovieIdsResult)
    }
}
