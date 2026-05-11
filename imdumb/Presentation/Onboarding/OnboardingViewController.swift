//
//  OnboardingViewController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit

final class OnboardingViewController: UIViewController, OnboardingViewProtocol {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var gotItButton: UIButton!

    var presenter: OnboardingPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        gotItButton.layer.cornerRadius = 12
    }

    @IBAction private func gotItTapped(_ sender: UIButton) {
        presenter?.didTapGotIt()
    }
}
