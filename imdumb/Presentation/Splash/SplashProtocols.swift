//
//  SplashProtocols.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

protocol SplashViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showWelcomeMessage(_ message: String)
    func showError(message: String)
}

protocol SplashPresenterProtocol {
    func viewDidLoad()
}

protocol SplashCoordinatorDelegate: AnyObject {
    func splashDidFinish(_ coordinator: SplashCoordinator)
}
