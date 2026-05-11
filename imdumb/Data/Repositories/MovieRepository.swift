//
//  MovieRepository.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {

    private let remoteDataSource: MovieDataSourceProtocol

    init(remoteDataSource: MovieDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchGenres(completion: @escaping (Result<[Category], Error>) -> Void) {
        remoteDataSource.fetchGenres { result in
            switch result {
            case .success(let dto):
                let categories = dto.genres.map { CategoryMapper.toDomain($0) }
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchMoviesByGenre(genreId: Int, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        remoteDataSource.fetchMoviesByGenre(genreId: genreId, page: page) { result in
            switch result {
            case .success(let dto):
                let movies = dto.results.map { MovieMapper.toDomain($0) }
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        remoteDataSource.fetchMovieDetail(movieId: movieId) { result in
            switch result {
            case .success(let dto):
                let movie = MovieMapper.toDomain(dto)
                completion(.success(movie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        remoteDataSource.searchMovies(query: query, page: page) { result in
            switch result {
            case .success(let dto):
                let movies = dto.results.map { MovieMapper.toDomain($0) }
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
