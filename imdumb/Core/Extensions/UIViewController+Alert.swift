//
//  UIViewController+Alert.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//


import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, retryAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let retryAction {
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default) { _ in
                retryAction()
            })
        }
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel))
        present(alert, animated: true)
    }
}