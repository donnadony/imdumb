//
//  MockUseCases.swift
//  IMDUMBTests
//
//  Created by Donnadony Mollo on 7/05/26.
//

@testable import IMDUMB

final class MockFetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {

    var result: Result<[Category], Error> = .success([])
    var executeCallCount = 0

    func execute(completion: @escaping (Result<[Category], Error>) -> Void) {
        executeCallCount += 1
        completion(result)
    }
}

