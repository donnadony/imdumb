//
//  RecommendMovieUseCase.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

protocol RecommendMovieUseCaseProtocol {
    func execute(movieId: Int, movieTitle: String, comment: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class RecommendMovieUseCase: RecommendMovieUseCaseProtocol {

    private let repository: RecommendationRepositoryProtocol

    init(repository: RecommendationRepositoryProtocol) {
        self.repository = repository
    }

    func execute(movieId: Int, movieTitle: String, comment: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let recommendation = Recommendation(
            movieId: movieId,
            movieTitle: movieTitle,
            comment: comment,
            createdAt: Date()
        )
        repository.save(recommendation, completion: completion)
    }
}
