//
//  FetchCategoriesUseCase.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

protocol FetchCategoriesUseCaseProtocol {
    
    func execute(completion: @escaping (Result<[Category], Error>) -> Void)
    
}

final class FetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {

    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[Category], Error>) -> Void) {
        repository.fetchGenres { result in
            switch result {
            case .success(let genres):
                let sorted = genres.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                completion(.success(sorted))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
