//
//  RemoteDataSource.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

final class RemoteDataSource: MovieDataSourceProtocol {
    
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchGenres(completion: @escaping (Result<GenreListDTO, NetworkError>) -> Void) {
        networkService.request(.getGenres, completion: completion)
    }

    func fetchMoviesByGenre(genreId: Int, page: Int, completion: @escaping (Result<MovieListDTO, NetworkError>) -> Void) {
        networkService.request(.getMoviesByGenre(genreId: genreId, page: page), completion: completion)
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetailDTO, NetworkError>) -> Void) {
        networkService.request(.getMovieDetail(movieId: movieId), completion: completion)
    }

    func searchMovies(query: String, page: Int, completion: @escaping (Result<MovieListDTO, NetworkError>) -> Void) {
        networkService.request(.searchMovies(query: query, page: page), completion: completion)
    }
}
