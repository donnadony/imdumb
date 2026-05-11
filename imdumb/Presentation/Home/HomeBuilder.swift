//
//  HomeBuilder.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

enum HomeBuilder {

    static func build(container: DIContainer, coordinator: HomeCoordinator) -> HomeViewController {
        let viewController = HomeViewController.fromNib()
        let presenter = HomePresenter(
            fetchCategoriesUseCase: container.makeFetchCategoriesUseCase(),
            movieRepository: container.movieRepository,
            favoriteRepository: container.favoriteRepository,
            recommendationRepository: container.recommendationRepository,
            onMovieSelected: { [weak coordinator] movieId in
                coordinator?.showDetail(movieId: movieId)
            }
        )
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
