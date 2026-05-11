//
//  SceneDelegate.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        let container = DIContainer()
        appCoordinator = AppCoordinator(
            window: window,
            navigationController: navigationController,
            container: container
        )
        appCoordinator?.start()
        self.window = window
    }
    
}