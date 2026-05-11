//
//  RecommendBuilder.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

enum RecommendBuilder {

    static func build(
        container: DIContainer,
        movie: Movie,
        onDismiss: @escaping () -> Void
    ) -> RecommendViewController {
        let viewController = RecommendViewController.fromNib()
        let presenter = RecommendPresenter(
            movie: movie,
            recommendUseCase: container.makeRecommendMovieUseCase(),
            onDismiss: onDismiss
        )
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
