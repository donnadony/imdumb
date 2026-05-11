//
//  FeaturedBannerCell.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit
import Kingfisher

final class FeaturedBannerCell: UICollectionViewCell {

    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!

    private var gradientLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradient()
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = gradientView.bounds
    }

    func configure(with movie: MovieViewModel) {
        titleLabel.text = movie.title.uppercased()
        bannerImageView.kf.setImage(
            with: movie.posterURL,
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )
    }

    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradient.locations = [0.3, 1.0]
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
}
