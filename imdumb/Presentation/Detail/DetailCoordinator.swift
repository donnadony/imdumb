//
//  DetailCoordinator.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class DetailCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var onFinish: (() -> Void)?
    private let container: DIContainer
    private let movieId: Int
    private weak var detailPresenter: DetailPresenterProtocol?

    init(navigationController: UINavigationController, container: DIContainer, movieId: Int) {
        self.navigationController = navigationController
        self.container = container
        self.movieId = movieId
    }

    func start() {
        let viewController = DetailBuilder.build(
            container: container,
            coordinator: self,
            movieId: movieId
        )
        detailPresenter = viewController.presenter
        navigationController.pushViewController(viewController, animated: true)
    }

    // MARK: - Navigation

    func showRecommend(movie: Movie) {
        let viewController = RecommendBuilder.build(
            container: container,
            movie: movie,
            onDismiss: { [weak self] in
                self?.detailPresenter?.viewWillAppear()
            }
        )
        viewController.modalPresentationStyle = .formSheet
        navigationController.present(viewController, animated: true)
    }
}
