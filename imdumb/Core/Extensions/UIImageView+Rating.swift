//
//  UIImageView+Rating.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit

extension UIImageView {

    func configureRatingStar(value: Double, pointSize: CGFloat = 12) {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .regular)
        let name: String
        let tint: UIColor
        if value >= 7.0 {
            name = "star.fill"
            tint = .systemYellow
        } else if value >= 4.0 {
            name = "star.leadinghalf.filled"
            tint = .systemYellow
        } else {
            name = "star"
            tint = .systemGray
        }
        image = UIImage(systemName: name, withConfiguration: config)
        tintColor = tint
    }
}
