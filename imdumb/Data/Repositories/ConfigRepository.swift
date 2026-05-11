//
//  ConfigRepository.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

final class ConfigRepository: ConfigRepositoryProtocol {
    
    private let firebaseDataSource: ConfigDataSourceProtocol

    init(firebaseDataSource: ConfigDataSourceProtocol) {
        self.firebaseDataSource = firebaseDataSource
    }

    func fetchConfig(completion: @escaping (Result<AppConfig, Error>) -> Void) {
        firebaseDataSource.fetchConfig(completion: completion)
    }
}
