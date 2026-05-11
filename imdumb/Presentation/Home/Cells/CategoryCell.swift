//
//  CategoryCell.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

protocol CategoryCellDelegate: AnyObject {
    func categoryCell(_ cell: CategoryCell, didSelectMovieWithId id: Int)
}

final class CategoryCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var moviesCollectionView: UICollectionView!

    // MARK: - Properties

    weak var delegate: CategoryCellDelegate?
    private var movies: [MovieViewModel] = []

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    // MARK: - Configuration

    func configure(name: String, movies: [MovieViewModel]) {
        categoryNameLabel.text = name
        self.movies = movies
        moviesCollectionView.reloadData()
    }

    // MARK: - Private

    private func setupCollectionView() {
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(MovieCell.nib, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.reuseIdentifier,
            for: indexPath
        ) as? MovieCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: movies[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoryCell(self, didSelectMovieWithId: movies[indexPath.item].id)
    }
}
