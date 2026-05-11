//
//  TopMatchCell.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit
import Kingfisher

final class TopMatchCell: UICollectionViewCell {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var topMatchLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!

    private let containerColor = UIColor(red: 0.15, green: 0.17, blue: 0.22, alpha: 1)

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.backgroundColor = containerColor
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
    }

    override var isHighlighted: Bool {
        didSet { containerView.backgroundColor = containerColor.withAlphaComponent(isHighlighted ? 0.7 : 1) }
    }

    override var isSelected: Bool {
        didSet { containerView.backgroundColor = containerColor }
    }

    func configure(with viewModel: TopMatchViewModel) {
        titleLabel.text = viewModel.title
        ratingLabel.text = viewModel.rating
        yearLabel.text = viewModel.year
        genresLabel.text = viewModel.genres
        overviewLabel.text = viewModel.overview
        posterImageView.kf.setImage(
            with: viewModel.posterURL,
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )
    }
}
