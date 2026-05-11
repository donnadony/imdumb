//
//  MockDataSource.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

final class MockDataSource: MovieDataSourceProtocol {

    func fetchGenres(completion: @escaping (Result<GenreListDTO, NetworkError>) -> Void) {
        guard let data = loadJSON("categories_mock") else {
            completion(.failure(.unknown("Mock file not found")))
            return
        }
        do {
            let dto = try JSONDecoder().decode(GenreListDTO.self, from: data)
            completion(.success(dto))
        } catch {
            completion(.failure(.decodingError))
        }
    }

    // TODO: add movies_by_genre_mock.json
    func fetchMoviesByGenre(genreId: Int, page: Int, completion: @escaping (Result<MovieListDTO, NetworkError>) -> Void) {
        completion(.success(MovieListDTO(page: 1, results: [], totalPages: 1, totalResults: 0)))
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailDTO, NetworkError>) -> Void) {
        guard let data = loadJSON("movie_detail_mock") else {
            completion(.failure(.unknown("Mock file not found")))
            return
        }
        do {
            let dto = try JSONDecoder().decode(MovieDetailDTO.self, from: data)
            completion(.success(dto))
        } catch {
            completion(.failure(.decodingError))
        }
    }

    func searchMovies(query: String, page: Int, completion: @escaping (Result<MovieListDTO, NetworkError>) -> Void) {
        completion(.success(MovieListDTO(page: 1, results: [], totalPages: 1, totalResults: 0)))
    }

    private func loadJSON(_ filename: String) -> Data? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else { return nil }
        return try? Data(contentsOf: url)
    }
}
