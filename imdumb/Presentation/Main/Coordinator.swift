//
//  Coordinator.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//


import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

extension Coordinator {

    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

extension Coordinator {

    func showDetail(movieId: Int, container: DIContainer, navigationController: UINavigationController) {
        let coordinator = DetailCoordinator(
            navigationController: navigationController,
            container: container,
            movieId: movieId
        )
        coordinator.onFinish = { [weak self, weak coordinator] in
            guard let coordinator else { return }
            self?.removeChild(coordinator)
        }
        addChild(coordinator)
        coordinator.start()
    }
}