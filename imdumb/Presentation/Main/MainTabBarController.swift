//
//  MainTabBarController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit

final class MainTabBarController: UITabBarController {

    var onShakeDetected: (() -> Void)?

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        onShakeDetected?()
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.14, alpha: 1)
        appearance.shadowColor = .clear

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.90, green: 0.16, blue: 0.24, alpha: 1)
        ]

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.90, green: 0.16, blue: 0.24, alpha: 1)

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
