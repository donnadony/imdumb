//
//  SplashCoordinator.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class SplashCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: SplashCoordinatorDelegate?
    private let container: DIContainer

    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewController = SplashBuilder.build(container: container, coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func didFinishSplash() {
        delegate?.splashDidFinish(self)
    }
}
