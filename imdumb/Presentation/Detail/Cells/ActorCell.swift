//
//  ActorCell.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class ActorCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var characterLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.cornerRadius = 30
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }

    // MARK: - Configuration

    func configure(with viewModel: ActorViewModel) {
        nameLabel.text = viewModel.name
        characterLabel.text = viewModel.character
        photoImageView.setImage(
            urlString: viewModel.photoURL?.absoluteString,
            placeholder: UIImage(systemName: "person.circle.fill")
        )
    }
}
