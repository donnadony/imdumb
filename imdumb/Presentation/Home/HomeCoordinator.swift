//
//  HomeCoordinator.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class HomeCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let container: DIContainer

    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewController = HomeBuilder.build(container: container, coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }

    func showDetail(movieId: Int) {
        showDetail(movieId: movieId, container: container, navigationController: navigationController)
    }

}
