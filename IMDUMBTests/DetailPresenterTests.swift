//
//  DetailPresenterTests.swift
//  IMDUMBTests
//
//  Created by Donnadony Mollo on 7/05/26.
//

import XCTest
@testable import IMDUMB

final class DetailPresenterTests: XCTestCase {

    private func makeSUT(
        movieId: Int = 1,
        detailResult: Result<Movie, Error>? = nil,
        checkFavoriteResult: Result<Bool, Error> = .success(false),
        showRecommendations: Bool = true,
        onRecommendTapped: @escaping (Movie) -> Void = { _ in }
    ) -> (DetailPresenter, MockDetailView, MockMovieRepository) {
        let mockView = MockDetailView()
        let mockMovieRepo = MockMovieRepository()
        if let result = detailResult {
            mockMovieRepo.fetchMovieDetailResult = result
        }
        let mockFavoriteRepo = MockFavoriteRepository()
        mockFavoriteRepo.isFavoriteResult = checkFavoriteResult
        let sut = DetailPresenter(
            movieId: movieId,
            movieRepository: mockMovieRepo,
            favoriteRepository: mockFavoriteRepo,
            recommendationRepository: MockRecommendationRepository(),
            showRecommendations: showRecommendations,
            onRecommendTapped: onRecommendTapped
        )
        sut.view = mockView
        return (sut, mockView, mockMovieRepo)
    }

    func test_viewDidLoad_showsLoading() {
        let (sut, mockView, _) = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(mockView.showLoadingCalled)
    }

    func test_viewDidLoad_showsDetail_onSuccess() {
        let movie = Movie.stub(title: "Avengers", voteAverage: 8.5, runtime: 143)
        let (sut, mockView, _) = makeSUT(detailResult: .success(movie))

        sut.viewDidLoad()

        let expectation = expectation(description: "main queue")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1.0)

        XCTAssertTrue(mockView.showDetailCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertEqual(mockView.receivedViewModel?.title, "Avengers")
        XCTAssertEqual(mockView.receivedViewModel?.rating, "8.5")
        XCTAssertEqual(mockView.receivedViewModel?.runtime, "2h 23m")
    }

    func test_viewDidLoad_showsError_onFailure() {
        let (sut, mockView, _) = makeSUT(
            detailResult: .failure(NSError(domain: "test", code: -1))
        )

        sut.viewDidLoad()

        let expectation = expectation(description: "main queue")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1.0)

        XCTAssertTrue(mockView.showErrorCalled)
    }

    func test_didTapRecommend_callsOnRecommendTapped() {
        var tappedMovie: Movie?
        let movie = Movie.stub(id: 55, title: "Recommended")
        let (sut, _, _) = makeSUT(
            movieId: 55,
            detailResult: .success(movie),
            onRecommendTapped: { tappedMovie = $0 }
        )

        sut.viewDidLoad()

        let expectation = expectation(description: "main queue")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1.0)

        sut.didTapRecommend()

        XCTAssertEqual(tappedMovie?.id, 55)
        XCTAssertEqual(tappedMovie?.title, "Recommended")
    }

    func test_viewDidLoad_checksFavoriteStatus() {
        let (sut, mockView, _) = makeSUT(checkFavoriteResult: .success(true))

        sut.viewDidLoad()

        let expectation = expectation(description: "main queue")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1.0)

        XCTAssertTrue(mockView.updateFavoriteButtonCalled)
        XCTAssertEqual(mockView.receivedIsFavorite, true)
        XCTAssertTrue(sut.isFavorite)
    }
}
