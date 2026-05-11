//
//  SplashViewController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class SplashViewController: UIViewController, SplashViewProtocol {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var welcomeLabel: UILabel!

    var presenter: SplashPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    // MARK: - SplashViewProtocol

    func showLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func showWelcomeMessage(_ message: String) {
        welcomeLabel.text = message
        welcomeLabel.isHidden = false
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.welcomeLabel.alpha = 1
        }
    }

    func showError(message: String) {
        showAlert(title: "Error", message: message) { [weak self] in
            self?.presenter?.viewDidLoad()
        }
    }

    private func setupUI() {
        welcomeLabel.isHidden = true
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
        logoImageView.image = UIImage(systemName: "film.fill", withConfiguration: config)
        logoImageView.tintColor = .white
    }
}
