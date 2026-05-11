//
//  DetailViewController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import UIKit

final class DetailViewController: UIViewController, DetailViewProtocol {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollContentView: UIView!
    @IBOutlet private weak var carouselCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingStarImageView: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var metaLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var castHeaderLabel: UILabel!
    @IBOutlet private weak var castCollectionView: UICollectionView!
    @IBOutlet private weak var bottomContainer: UIView!
    @IBOutlet private weak var recommendButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var recommendationsHeaderLabel: UILabel!
    @IBOutlet private weak var recommendationsContentLabel: UILabel!

    var presenter: DetailPresenterProtocol?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollections()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        presenter?.viewWillAppear()
    }

    // MARK: - DetailViewProtocol

    func showLoading() {
        activityIndicator.startAnimating()
        scrollView.isHidden = true
        bottomContainer.isHidden = true
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        scrollView.isHidden = false
    }

    func showDetail(_ viewModel: DetailViewModel) {
        titleLabel.text = viewModel.title
        ratingLabel.text = viewModel.rating
        ratingStarImageView.configureRatingStar(value: viewModel.ratingValue, pointSize: 16)

        var metaParts: [String] = []
        if !viewModel.releaseDate.isEmpty { metaParts.append(viewModel.releaseDate) }
        if !viewModel.runtime.isEmpty { metaParts.append(viewModel.runtime) }
        if !viewModel.genres.isEmpty { metaParts.append(viewModel.genres) }
        metaLabel.text = metaParts.joined(separator: " · ")

        overviewLabel.text = viewModel.overview

        let imageCount = presenter?.imageURLs.count ?? 0
        pageControl.numberOfPages = imageCount
        pageControl.currentPage = 0
        pageControl.isHidden = imageCount <= 1
        carouselCollectionView.reloadData()

        let actorsEmpty = presenter?.actors.isEmpty ?? true
        castHeaderLabel.isHidden = actorsEmpty
        castCollectionView.isHidden = actorsEmpty
        castCollectionView.reloadData()
    }

    func showError(message: String) {
        showAlert(title: "Error", message: message) { [weak self] in
            self?.presenter?.viewDidLoad()
        }
    }

    func configureRecommendButton(visible: Bool) {
        bottomContainer.isHidden = !visible
    }

    func updateFavoriteButton(isFavorite: Bool) {
        let name = isFavorite ? "heart.fill" : "heart"
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        favoriteButton.setImage(UIImage(systemName: name, withConfiguration: config), for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .white
    }

    func showRecommendations(_ recommendations: [RecommendationViewModel]) {
        guard !recommendations.isEmpty else {
            recommendationsHeaderLabel.isHidden = true
            recommendationsContentLabel.isHidden = true
            return
        }
        recommendationsHeaderLabel.isHidden = false
        recommendationsContentLabel.isHidden = false
        recommendationsHeaderLabel.text = "Recomendaciones (\(recommendations.count))"

        let text = recommendations.map { "\"\($0.comment)\" — \($0.date)" }.joined(separator: "\n\n")
        recommendationsContentLabel.text = text
    }

    // MARK: - Actions

    @IBAction private func recommendTapped(_ sender: UIButton) {
        presenter?.didTapRecommend()
    }

    @IBAction private func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func favoriteTapped(_ sender: UIButton) {
        presenter?.didTapFavorite()
    }

    // MARK: - Setup

    private func setupUI() {
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        view.bringSubviewToFront(backButton)
        view.bringSubviewToFront(favoriteButton)
    }

    private func setupCollections() {
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.register(ImageCarouselCell.nib, forCellWithReuseIdentifier: ImageCarouselCell.reuseIdentifier)

        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.register(ActorCell.nib, forCellWithReuseIdentifier: ActorCell.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource

extension DetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselCollectionView {
            return presenter?.imageURLs.count ?? 0
        }
        return presenter?.actors.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == carouselCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCarouselCell.reuseIdentifier,
                for: indexPath
            ) as? ImageCarouselCell,
                  let url = presenter?.imageURLs[indexPath.item] else {
                return UICollectionViewCell()
            }
            cell.configure(with: url)
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ActorCell.reuseIdentifier,
            for: indexPath
        ) as? ActorCell,
              let actor = presenter?.actors[indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.configure(with: actor)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == carouselCollectionView {
            return collectionView.bounds.size
        }
        return CGSize(width: 80, height: 110)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == carouselCollectionView else { return }
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }
}
