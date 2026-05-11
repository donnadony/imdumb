import UIKit

final class AlertModalViewController: UIViewController {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!

    private var alertTitle: String = ""
    private var alertMessage: String = ""
    private var buttonTitle: String = "OK"
    private var iconName: String = "checkmark.seal.fill"
    private var onAction: (() -> Void)?

    static func make(
        title: String,
        message: String,
        buttonTitle: String = "OK",
        iconName: String = "checkmark.seal.fill",
        onAction: @escaping () -> Void
    ) -> AlertModalViewController {
        let viewController = AlertModalViewController.fromNib()
        viewController.alertTitle = title
        viewController.alertMessage = message
        viewController.buttonTitle = buttonTitle
        viewController.iconName = iconName
        viewController.onAction = onAction
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = alertTitle
        messageLabel.text = alertMessage
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.layer.cornerRadius = 12
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
    }

    @IBAction private func actionTapped(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.onAction?()
        }
    }
}
