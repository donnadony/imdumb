//
//  MovieCell.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class MovieCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var recommendedImageView: UIImageView!

    var onFavoriteTapped: (() -> Void)?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.clipsToBounds = true
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        favoriteImageView.image = UIImage(systemName: "heart.fill", withConfiguration: config)
        recommendedImageView.image = UIImage(systemName: "text.bubble.fill", withConfiguration: config)
        favoriteImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        favoriteImageView.addGestureRecognizer(tap)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        favoriteImageView.isHidden = true
        recommendedImageView.isHidden = true
        onFavoriteTapped = nil
    }

    @objc private func favoriteTapped() {
        onFavoriteTapped?()
    }

    // MARK: - Configuration

    func configure(with viewModel: MovieViewModel) {
        titleLabel.text = viewModel.title
        ratingLabel.text = viewModel.rating
        yearLabel.text = viewModel.year
        posterImageView.setImage(urlString: viewModel.posterURL?.absoluteString)
        starImageView.configureRatingStar(value: Double(viewModel.rating) ?? 0, pointSize: 10)
        favoriteImageView.isHidden = !viewModel.isFavorite
        recommendedImageView.isHidden = !viewModel.isRecommended
    }
}
