import UIKit

final class FavoritesCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let container: DIContainer

    init(navigationController: UINavigationController, container: DIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewController = FavoritesBuilder.build(container: container, coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showDetail(movieId: Int) {
        showDetail(movieId: movieId, container: container, navigationController: navigationController)
    }
}
