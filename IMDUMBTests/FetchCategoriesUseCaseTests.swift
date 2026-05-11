//
//  FetchCategoriesUseCaseTests.swift
//  IMDUMBTests
//
//  Created by Donnadony Mollo on 7/05/26.
//

import XCTest
@testable import IMDUMB

final class FetchCategoriesUseCaseTests: XCTestCase {

    func test_execute_callsRepository() {
        let mockRepo = MockMovieRepository()
        let sut = FetchCategoriesUseCase(repository: mockRepo)

        sut.execute { _ in }

        XCTAssertEqual(mockRepo.fetchGenresCallCount, 1)
    }

    func test_execute_returnsCategories_onSuccess() {
        let mockRepo = MockMovieRepository()
        let expected = [Category(id: 1, name: "Action", movies: [])]
        mockRepo.fetchGenresResult = .success(expected)
        let sut = FetchCategoriesUseCase(repository: mockRepo)
        let expectation = expectation(description: "fetch")

        sut.execute { result in
            if case .success(let categories) = result {
                XCTAssertEqual(categories.count, 1)
                XCTAssertEqual(categories.first?.name, "Action")
            } else {
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_execute_returnsError_onFailure() {
        let mockRepo = MockMovieRepository()
        mockRepo.fetchGenresResult = .failure(NSError(domain: "test", code: -1))
        let sut = FetchCategoriesUseCase(repository: mockRepo)
        let expectation = expectation(description: "fetch")

        sut.execute { result in
            guard case .failure = result else {
                XCTFail("Expected failure")
                expectation.fulfill()
                return
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
