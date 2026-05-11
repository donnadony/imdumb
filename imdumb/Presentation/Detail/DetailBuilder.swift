//
//  DetailBuilder.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

enum DetailBuilder {

    static func build(
        container: DIContainer,
        coordinator: DetailCoordinator,
        movieId: Int
    ) -> DetailViewController {
        let viewController = DetailViewController.fromNib()
        let presenter = DetailPresenter(
            movieId: movieId,
            movieRepository: container.movieRepository,
            favoriteRepository: container.favoriteRepository,
            recommendationRepository: container.recommendationRepository,
            showRecommendations: AppSettings.showRecommendations,
            onRecommendTapped: { [weak coordinator] movie in
                coordinator?.showRecommend(movie: movie)
            }
        )
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
