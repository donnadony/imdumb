//
//  SearchBuilder.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

enum SearchBuilder {

    static func build(
        container: DIContainer,
        onMovieSelected: @escaping (Int) -> Void
    ) -> SearchViewController {
        let viewController = SearchViewController.fromNib()
        let presenter = SearchPresenter(
            movieRepository: container.movieRepository,
            favoriteRepository: container.favoriteRepository,
            recommendationRepository: container.recommendationRepository,
            onMovieSelected: onMovieSelected
        )
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
