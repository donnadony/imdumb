//
//  SplashPresenter.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

final class SplashPresenter: SplashPresenterProtocol {

    weak var view: SplashViewProtocol?
    private let configRepository: ConfigRepositoryProtocol
    private let onFinish: () -> Void
    private let dispatcher: Dispatching

    init(
        configRepository: ConfigRepositoryProtocol,
        onFinish: @escaping () -> Void,
        dispatcher: Dispatching = DispatchQueue.main
    ) {
        self.configRepository = configRepository
        self.onFinish = onFinish
        self.dispatcher = dispatcher
    }

    func viewDidLoad() {
        view?.showLoading()
        configRepository.fetchConfig { [weak self] result in
            self?.dispatcher.dispatch {
                self?.handleConfigResult(result)
            }
        }
    }

    private func handleConfigResult(_ result: Result<AppConfig, Error>) {
        view?.hideLoading()
        switch result {
        case .success(let config):
            AppSettings.showRecommendations = config.showRecommendations
            AppSettings.appVersion = config.appVersion
            AppSettings.welcomeMessage = config.welcomeMessage
            AppSettings.environment = config.environment
            view?.showWelcomeMessage(config.welcomeMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.onFinish()
            }
        case .failure(let error):
            let message = (error as? NetworkError)?.userMessage ?? "No se pudo cargar la configuración"
            view?.showError(message: message)
        }
    }
}
