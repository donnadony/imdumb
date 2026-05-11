//
//  LocalStateLoader.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import Foundation

struct LocalStateSnapshot {
    let favoriteIds: Set<Int>
    let recommendedIds: Set<Int>
}

struct LocalStateLoader {

    private let favoriteRepository: FavoriteRepositoryProtocol
    private let recommendationRepository: RecommendationRepositoryProtocol

    init(
        favoriteRepository: FavoriteRepositoryProtocol,
        recommendationRepository: RecommendationRepositoryProtocol
    ) {
        self.favoriteRepository = favoriteRepository
        self.recommendationRepository = recommendationRepository
    }

    func load(completion: @escaping (LocalStateSnapshot) -> Void) {
        let group = DispatchGroup()
        var favoriteIds: Set<Int> = []
        var recommendedIds: Set<Int> = []

        group.enter()
        favoriteRepository.fetchAll { result in
            if case .success(let favorites) = result {
                favoriteIds = Set(favorites.map { $0.id })
            }
            group.leave()
        }

        group.enter()
        recommendationRepository.fetchRecommendedMovieIds { result in
            if case .success(let ids) = result {
                recommendedIds = ids
            }
            group.leave()
        }

        group.notify(queue: .main) {
            completion(LocalStateSnapshot(favoriteIds: favoriteIds, recommendedIds: recommendedIds))
        }
    }
}
