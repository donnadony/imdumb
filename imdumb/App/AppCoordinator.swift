//
//  AppCoordinator.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let container: DIContainer
    private let window: UIWindow

    init(
        window: UIWindow,
        navigationController: UINavigationController,
        container: DIContainer
    ) {
        self.window = window
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let splashCoordinator = SplashCoordinator(
            navigationController: navigationController,
            container: container
        )
        splashCoordinator.delegate = self
        addChild(splashCoordinator)
        splashCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func setupTabBar() {
        let tabBarController = MainTabBarController()

        let homeNav = createNavController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNav, container: container)
        addChild(homeCoordinator)
        homeCoordinator.start()
        homeNav.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house.fill"), tag: 0)

        let searchNav = createNavController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNav, container: container)
        addChild(searchCoordinator)
        searchCoordinator.start()
        searchNav.tabBarItem = UITabBarItem(title: "Buscar", image: UIImage(systemName: "magnifyingglass"), tag: 1)

        let favoritesNav = createNavController()
        let favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNav, container: container)
        addChild(favoritesCoordinator)
        favoritesCoordinator.start()
        favoritesNav.tabBarItem = UITabBarItem(title: "Mi Lista", image: UIImage(systemName: "heart.fill"), tag: 2)

        let profileNav = createNavController()
        let profileVC = ComingSoonViewController(
            nibName: String(describing: ComingSoonViewController.self),
            bundle: nil
        )
        profileNav.setViewControllers([profileVC], animated: false)
        profileNav.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person.fill"), tag: 3)

        tabBarController.viewControllers = [homeNav, searchNav, favoritesNav, profileNav]

        tabBarController.onShakeDetected = { [weak self] in
            self?.showDebug()
        }

        window.rootViewController = tabBarController

        if !AppSettings.hasSeenOnboarding {
            showOnboarding()
        }
    }

    private func showOnboarding() {
        let viewController = OnboardingBuilder.build(onDismiss: { [weak self] in
            AppSettings.hasSeenOnboarding = true
            self?.window.rootViewController?.dismiss(animated: true)
        })
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.window.rootViewController?.present(viewController, animated: true)
        }
    }

    private func showDebug() {
        guard window.rootViewController?.presentedViewController == nil else { return }
        let viewController = DebugBuilder.build(onDismiss: { [weak self] in
            self?.window.rootViewController?.dismiss(animated: true)
        })
        viewController.modalPresentationStyle = .formSheet
        window.rootViewController?.present(viewController, animated: true)
    }

    private func createNavController() -> UINavigationController {
        let nav = UINavigationController()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navBarBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.tintColor = .white
        return nav
    }
}

// MARK: - SplashCoordinatorDelegate

extension AppCoordinator: SplashCoordinatorDelegate {

    func splashDidFinish(_ coordinator: SplashCoordinator) {
        removeChild(coordinator)
        setupTabBar()
    }
}

extension UIColor {
    static let navBarBackground = UIColor(red: 0.129, green: 0.145, blue: 0.180, alpha: 1)
}
