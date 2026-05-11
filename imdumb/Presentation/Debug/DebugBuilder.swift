//
//  DebugBuilder.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

enum DebugBuilder {

    static func build(onDismiss: @escaping () -> Void) -> DebugViewController {
        let viewController = DebugViewController.fromNib()
        let presenter = DebugPresenter(onDismiss: onDismiss)
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
