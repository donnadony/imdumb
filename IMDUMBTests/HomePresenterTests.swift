//
//  HomePresenterTests.swift
//  IMDUMBTests
//
//  Created by Donnadony Mollo on 7/05/26.
//

import XCTest
@testable import IMDUMB

final class HomePresenterTests: XCTestCase {

    private func makeSUT(
        categoriesResult: Result<[IMDUMB.Category], Error> = .success([]),
        onMovieSelected: @escaping (Int) -> Void = { _ in }
    ) -> (HomePresenter, MockHomeView) {
        let mockView = MockHomeView()
        let mockUseCase = MockFetchCategoriesUseCase()
        mockUseCase.result = categoriesResult
        let sut = HomePresenter(
            fetchCategoriesUseCase: mockUseCase,
            movieRepository: MockMovieRepository(),
            favoriteRepository: MockFavoriteRepository(),
            recommendationRepository: MockRecommendationRepository(),
            onMovieSelected: onMovieSelected
        )
        sut.view = mockView
        return (sut, mockView)
    }

    func test_viewDidLoad_showsLoading() {
        let (sut, mockView) = makeSUT()
        sut.viewDidLoad()
        XCTAssertTrue(mockView.showLoadingCalled)
    }

    func test_viewDidLoad_showsError_onFailure() {
        let (sut, mockView) = makeSUT(
            categoriesResult: .failure(NSError(domain: "test", code: -1))
        )

        sut.viewDidLoad()

        let expectation = expectation(description: "main queue")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1.0)

        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    func test_viewDidLoad_showsEmptyState_whenNoCategories() {
        let (sut, mockView) = makeSUT(categoriesResult: .success([]))

        sut.viewDidLoad()

        let expectation = expectation(description: "main queue")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1.0)

        XCTAssertTrue(mockView.showEmptyStateCalled)
    }

    func test_didSelectMovie_callsOnMovieSelected() {
        var selectedId: Int?
        let (sut, _) = makeSUT(onMovieSelected: { selectedId = $0 })

        sut.didSelectMovie(movieId: 123)

        XCTAssertEqual(selectedId, 123)
    }
}
