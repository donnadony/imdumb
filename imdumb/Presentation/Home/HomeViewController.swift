//
//  HomeViewController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class HomeViewController: UIViewController, HomeViewProtocol {

    @IBOutlet private weak var collectionView: UICollectionView!

    var presenter: HomePresenterProtocol?
    private let refreshControl = UIRefreshControl()

    private enum Section: Int, CaseIterable {
        case featured
        case categories
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        presenter?.viewWillAppear()
    }

    // MARK: - HomeViewProtocol

    func showLoading() {
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
    }

    func hideLoading() {
        refreshControl.endRefreshing()
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func showError(message: String) {
        showAlert(title: "Error", message: message) { [weak self] in
            self?.presenter?.viewDidLoad()
        }
    }

    func showEmptyState() {
        collectionView.reloadData()
    }

    private func setupNavigationBar() {
        title = "IMDUMB"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navBarBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.90, green: 0.16, blue: 0.24, alpha: 1),
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy)
        ]
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeaturedBannerCell.nib, forCellWithReuseIdentifier: FeaturedBannerCell.reuseIdentifier)
        collectionView.register(CategoryCell.nib, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        collectionView.collectionViewLayout = layout
    }

    @objc private func handleRefresh() {
        presenter?.didPullToRefresh()
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        switch sectionType {
        case .featured:
            return presenter?.featuredMovie != nil ? 1 : 0
        case .categories:
            return presenter?.categories.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch sectionType {
        case .featured:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedBannerCell.reuseIdentifier,
                for: indexPath
            ) as? FeaturedBannerCell,
                  let movie = presenter?.featuredMovie else {
                return UICollectionViewCell()
            }
            cell.configure(with: movie)
            return cell
        case .categories:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCell.reuseIdentifier,
                for: indexPath
            ) as? CategoryCell,
                  let category = presenter?.categories[indexPath.item] else {
                return UICollectionViewCell()
            }
            cell.configure(name: category.name, movies: category.movies)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return .zero
        }
        switch sectionType {
        case .featured:
            let width = collectionView.bounds.width - 32
            return CGSize(width: width, height: width * 1.1)
        case .categories:
            let headerHeight: CGFloat = 38
            let movieRowHeight: CGFloat = 232
            return CGSize(width: collectionView.bounds.width, height: headerHeight + movieRowHeight)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let sectionType = Section(rawValue: section) else {
            return .zero
        }
        switch sectionType {
        case .featured:
            return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        case .categories:
            return UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = Section(rawValue: indexPath.section) else { return }
        if sectionType == .featured, let movie = presenter?.featuredMovie {
            presenter?.didSelectMovie(movieId: movie.id)
        }
    }
}

// MARK: - CategoryCellDelegate

extension HomeViewController: CategoryCellDelegate {

    func categoryCell(_ cell: CategoryCell, didSelectMovieWithId id: Int) {
        presenter?.didSelectMovie(movieId: id)
    }
}
