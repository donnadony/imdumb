//
//  RecommendViewController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class RecommendViewController: UIViewController, RecommendViewProtocol {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollContentView: UIView!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var presenter: RecommendPresenterProtocol?
    private let placeholderText = "Escribe tu comentario..."

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        presenter?.viewDidLoad()
    }

    // MARK: - RecommendViewProtocol

    func showMovieInfo(title: String, overview: String) {
        titleLabel.text = title
        overviewLabel.text = overview
    }

    func showSuccess() {
        let modal = AlertModalViewController.make(
            title: "Recomendación enviada",
            message: "Tu recomendación fue enviada exitosamente",
            iconName: "checkmark.seal.fill"
        ) { [weak self] in
            self?.dismiss(animated: true) {
                self?.presenter?.dismiss()
            }
        }
        present(modal, animated: true)
    }

    func showError(message: String) {
        showAlert(title: "Error", message: message, retryAction: nil)
    }

    func showLoading() {
        activityIndicator.startAnimating()
        confirmButton.isEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func setConfirmButtonEnabled(_ enabled: Bool) {
        confirmButton.isEnabled = enabled
        confirmButton.alpha = enabled ? 1.0 : 0.5
    }

    // MARK: - Actions

    @IBAction private func confirmTapped(_ sender: UIButton) {
        let comment = commentTextView.text == placeholderText ? "" : commentTextView.text ?? ""
        presenter?.didTapConfirm(comment: comment)
    }

    @IBAction private func closeTapped(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.presenter?.dismiss()
        }
    }

    // MARK: - Private

    private func setupUI() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        commentTextView.text = placeholderText
        commentTextView.textColor = .secondaryLabel
        commentTextView.delegate = self
        commentTextView.layer.borderColor = UIColor.separator.cgColor
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height
        scrollView.verticalScrollIndicatorInsets.bottom = frame.height
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

// MARK: - UITextViewDelegate

extension RecommendViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = .secondaryLabel
            presenter?.didChangeComment("")
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        presenter?.didChangeComment(textView.text)
    }
}
