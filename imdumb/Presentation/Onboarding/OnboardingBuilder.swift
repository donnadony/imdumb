//
//  OnboardingBuilder.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

enum OnboardingBuilder {

    static func build(onDismiss: @escaping () -> Void) -> OnboardingViewController {
        let viewController = OnboardingViewController.fromNib()
        let presenter = OnboardingPresenter(onDismiss: onDismiss)
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
