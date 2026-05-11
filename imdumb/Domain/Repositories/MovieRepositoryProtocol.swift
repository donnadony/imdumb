//
//  MovieRepositoryProtocol.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

protocol MovieRepositoryProtocol {

    func fetchGenres(completion: @escaping (Result<[Category], Error>) -> Void)
    func fetchMoviesByGenre(genreId: Int, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void)
    func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)

}
