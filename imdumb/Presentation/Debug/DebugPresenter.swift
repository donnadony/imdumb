//
//  DebugPresenter.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import Foundation

final class DebugPresenter: DebugPresenterProtocol {

    weak var view: DebugViewProtocol?
    private(set) var items: [DebugConfigItem] = []
    private let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    func viewDidLoad() {
        loadItems()
    }

    func didToggleItem(at index: Int) {
        guard index < items.count else { return }
        let item = items[index]
        guard case .toggle(let current) = item.value else { return }

        switch item.key {
        case "show_recommendations":
            AppSettings.showRecommendations = !current
        default:
            break
        }

        loadItems()
    }

    func didTapDismiss() {
        onDismiss()
    }

    private func loadItems() {
        items = [
            DebugConfigItem(
                key: "show_recommendations",
                displayName: "Mostrar Recomendaciones",
                value: .toggle(AppSettings.showRecommendations)
            ),
            DebugConfigItem(
                key: "environment",
                displayName: "Entorno",
                value: .text(AppSettings.environment)
            ),
            DebugConfigItem(
                key: "app_version",
                displayName: "Versión",
                value: .text(AppSettings.appVersion)
            ),
            DebugConfigItem(
                key: "welcome_message",
                displayName: "Mensaje de Bienvenida",
                value: .text(AppSettings.welcomeMessage)
            )
        ]
        view?.reloadData()
    }
}
