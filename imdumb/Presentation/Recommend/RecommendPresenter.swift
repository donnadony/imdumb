//
//  RecommendPresenter.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

final class RecommendPresenter: RecommendPresenterProtocol {

    weak var view: RecommendViewProtocol?
    private let movie: Movie
    private let recommendUseCase: RecommendMovieUseCaseProtocol
    private let onDismiss: () -> Void
    private let dispatcher: Dispatching

    init(
        movie: Movie,
        recommendUseCase: RecommendMovieUseCaseProtocol,
        onDismiss: @escaping () -> Void,
        dispatcher: Dispatching = DispatchQueue.main
    ) {
        self.movie = movie
        self.recommendUseCase = recommendUseCase
        self.onDismiss = onDismiss
        self.dispatcher = dispatcher
    }

    // MARK: - RecommendPresenterProtocol

    func viewDidLoad() {
        view?.showMovieInfo(title: movie.title, overview: movie.overview)
        view?.setConfirmButtonEnabled(false)
    }

    func didChangeComment(_ text: String) {
        let hasContent = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        view?.setConfirmButtonEnabled(hasContent)
    }

    func didTapConfirm(comment: String) {
        view?.showLoading()
        recommendUseCase.execute(movieId: movie.id, movieTitle: movie.title, comment: comment) { [weak self] result in
            self?.dispatcher.dispatch {
                self?.view?.hideLoading()
                switch result {
                case .success:
                    self?.view?.showSuccess()
                case .failure:
                    self?.view?.showError(message: "Error al guardar la recomendación")
                }
            }
        }
    }

    func dismiss() {
        onDismiss()
    }
}
