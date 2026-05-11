//
//  ConfigRepositoryProtocol.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

protocol ConfigRepositoryProtocol {
    
    func fetchConfig(completion: @escaping (Result<AppConfig, Error>) -> Void)
    
}
