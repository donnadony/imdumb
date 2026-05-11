//
//  SplashBuilder.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

enum SplashBuilder {

    static func build(container: DIContainer, coordinator: SplashCoordinator) -> SplashViewController {
        let viewController = SplashViewController.fromNib()
        let presenter = SplashPresenter(
            configRepository: container.configRepository,
            onFinish: { [weak coordinator] in
                coordinator?.didFinishSplash()
            }
        )
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
