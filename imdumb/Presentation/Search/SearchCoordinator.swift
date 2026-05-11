//
//  SearchCoordinator.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit

final class SearchCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let container: DIContainer

    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewController = SearchBuilder.build(
            container: container,
            onMovieSelected: { [weak self] movieId in
                self?.showDetail(movieId: movieId)
            }
        )
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showDetail(movieId: Int) {
        showDetail(movieId: movieId, container: container, navigationController: navigationController)
    }
}
