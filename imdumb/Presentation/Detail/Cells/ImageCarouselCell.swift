//
//  ImageCarouselCell.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class ImageCarouselCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Configuration

    func configure(with url: URL) {
        imageView.setImage(urlString: url.absoluteString)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
