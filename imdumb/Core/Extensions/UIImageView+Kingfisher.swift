//
//  UIImageView+Kingfisher.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//


import UIKit
import Kingfisher

extension UIImageView {

    func setImage(urlString: String?, placeholder: UIImage? = nil) {
        guard let urlString, let url = URL(string: urlString) else {
            image = placeholder
            return
        }
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )
    }
}