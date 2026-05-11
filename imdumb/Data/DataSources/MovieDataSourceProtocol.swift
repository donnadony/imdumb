//
//  MovieDataSourceProtocol.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

protocol MovieDataSourceProtocol {

    func fetchGenres(completion: @escaping (Result<GenreListDTO, NetworkError>) -> Void)
    func fetchMoviesByGenre(genreId: Int, page: Int, completion: @escaping (Result<MovieListDTO, NetworkError>) -> Void)
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailDTO, NetworkError>) -> Void)
    func searchMovies(query: String, page: Int, completion: @escaping (Result<MovieListDTO, NetworkError>) -> Void)

}
