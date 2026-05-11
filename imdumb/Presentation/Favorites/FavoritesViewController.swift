//
//  FavoritesViewController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit
import Foundation

final class FavoritesViewController: UIViewController, FavoritesViewProtocol {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var emptyIcon: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var presenter: FavoritesPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mi Lista"
        setupCollectionView()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        presenter?.viewWillAppear()
    }

    // MARK: - FavoritesViewProtocol

    func showLoading() {
        activityIndicator.startAnimating()
        emptyLabel.isHidden = true
        emptyIcon.isHidden = true
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func reloadData() {
        collectionView.isHidden = false
        emptyLabel.isHidden = true
        emptyIcon.isHidden = true
        collectionView.reloadData()
    }

    func showEmptyState() {
        collectionView.isHidden = true
        emptyLabel.isHidden = false
        emptyIcon.isHidden = false
        emptyLabel.text = "Aún no tienes películas favoritas"
    }

    func showError(message: String) {
        showAlert(title: "Error", message: message, retryAction: nil)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.nib, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.movies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.reuseIdentifier,
            for: indexPath
        ) as? MovieCell,
              let movie = presenter?.movies[indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.configure(with: movie)
        cell.onFavoriteTapped = { [weak self] in
            self?.presenter?.didTapFavorite(movieId: movie.id)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        collectionView.movieGridItemSize(columns: 3)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        12
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = presenter?.movies[indexPath.item] else { return }
        presenter?.didSelectMovie(movieId: movie.id)
    }
}
