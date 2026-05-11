import UIKit

extension UIViewController {

    static func fromNib() -> Self {
        Self(nibName: String(describing: Self.self), bundle: nil)
    }
}
