//
//  MockViews.swift
//  IMDUMBTests
//
//  Created by Donnadony Mollo on 7/05/26.
//

@testable import IMDUMB

final class MockHomeView: HomeViewProtocol {

    var showLoadingCalled = false
    var hideLoadingCalled = false
    var reloadDataCalled = false
    var showErrorCalled = false
    var showEmptyStateCalled = false
    var receivedErrorMessage: String?

    func showLoading() { showLoadingCalled = true }
    func hideLoading() { hideLoadingCalled = true }
    func reloadData() { reloadDataCalled = true }

    func showError(message: String) {
        showErrorCalled = true
        receivedErrorMessage = message
    }

    func showEmptyState() { showEmptyStateCalled = true }
}

final class MockDetailView: DetailViewProtocol {

    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showDetailCalled = false
    var showErrorCalled = false
    var configureRecommendButtonCalled = false
    var receivedViewModel: DetailViewModel?
    var receivedErrorMessage: String?
    var receivedRecommendVisible: Bool?

    func showLoading() { showLoadingCalled = true }
    func hideLoading() { hideLoadingCalled = true }

    func showDetail(_ viewModel: DetailViewModel) {
        showDetailCalled = true
        receivedViewModel = viewModel
    }

    func showError(message: String) {
        showErrorCalled = true
        receivedErrorMessage = message
    }

    func configureRecommendButton(visible: Bool) {
        configureRecommendButtonCalled = true
        receivedRecommendVisible = visible
    }

    var updateFavoriteButtonCalled = false
    var receivedIsFavorite: Bool?

    func updateFavoriteButton(isFavorite: Bool) {
        updateFavoriteButtonCalled = true
        receivedIsFavorite = isFavorite
    }

    var showRecommendationsCalled = false
    var receivedRecommendations: [RecommendationViewModel]?

    func showRecommendations(_ recommendations: [RecommendationViewModel]) {
        showRecommendationsCalled = true
        receivedRecommendations = recommendations
    }
}
