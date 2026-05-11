import UIKit

enum FavoritesBuilder {

    static func build(
        container: DIContainer,
        coordinator: FavoritesCoordinator
    ) -> FavoritesViewController {
        let viewController = FavoritesViewController.fromNib()
        let presenter = FavoritesPresenter(
            favoriteRepository: container.favoriteRepository,
            onMovieSelected: { [weak coordinator] movieId in
                coordinator?.showDetail(movieId: movieId)
            }
        )
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
