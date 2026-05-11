//
//  RecommendationDataSourceProtocol.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

protocol RecommendationDataSourceProtocol {
    func save(_ recommendation: Recommendation)
    func fetchForMovie(movieId: Int) -> [Recommendation]
    func fetchAllMovieIds() -> Set<Int>
}
