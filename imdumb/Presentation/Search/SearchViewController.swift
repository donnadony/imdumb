//
//  SearchViewController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class SearchViewController: UIViewController, SearchViewProtocol {

    // MARK: - Outlets

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var presenter: SearchPresenterProtocol?

    private enum Section: Int, CaseIterable {
        case topMatch
        case results
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar"
        setupSearchBar()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - SearchViewProtocol

    func showLoading() {
        activityIndicator.startAnimating()
        emptyLabel.isHidden = true
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func reloadData() {
        collectionView.isHidden = false
        emptyLabel.isHidden = true
        collectionView.reloadData()
    }

    func showError(message: String) {
        showAlert(title: "Error", message: message, retryAction: nil)
    }

    func showEmptyState() {
        collectionView.isHidden = true
        emptyLabel.isHidden = false
        emptyLabel.text = "No se encontraron películas"
    }

    func showInitialState() {
        collectionView.isHidden = true
        emptyLabel.isHidden = false
        emptyLabel.text = "Busca tu película favorita"
    }

    // MARK: - Private

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.overrideUserInterfaceStyle = .dark
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TopMatchCell.nib, forCellWithReuseIdentifier: TopMatchCell.reuseIdentifier)
        collectionView.register(MovieCell.nib, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isHidden = true
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didChangeQuery(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        switch sectionType {
        case .topMatch:
            return presenter?.topMatch != nil ? 1 : 0
        case .results:
            return presenter?.movies.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch sectionType {
        case .topMatch:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TopMatchCell.reuseIdentifier,
                for: indexPath
            ) as? TopMatchCell,
                  let topMatch = presenter?.topMatch else {
                return UICollectionViewCell()
            }
            cell.configure(with: topMatch)
            return cell
        case .results:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCell.reuseIdentifier,
                for: indexPath
            ) as? MovieCell,
                  let movie = presenter?.movies[indexPath.item] else {
                return UICollectionViewCell()
            }
            cell.configure(with: movie)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let sectionType = Section(rawValue: indexPath.section) else { return .zero }
        switch sectionType {
        case .topMatch:
            return CGSize(width: collectionView.bounds.width - 32, height: 180)
        case .results:
            return collectionView.movieGridItemSize(columns: 4)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let sectionType = Section(rawValue: section) else { return .zero }
        switch sectionType {
        case .topMatch:
            return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        case .results:
            return UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        }
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
        guard let sectionType = Section(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .topMatch:
            guard let topMatch = presenter?.topMatch else { return }
            presenter?.didSelectMovie(movieId: topMatch.id)
        case .results:
            guard let movie = presenter?.movies[indexPath.item] else { return }
            presenter?.didSelectMovie(movieId: movie.id)
        }
    }
}
