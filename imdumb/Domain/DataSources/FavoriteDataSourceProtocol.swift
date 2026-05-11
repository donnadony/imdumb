//
//  FavoriteDataSourceProtocol.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

protocol FavoriteDataSourceProtocol {
    func fetchAll() -> [FavoriteMovie]
    func add(_ movie: FavoriteMovie)
    func remove(movieId: Int)
    func exists(movieId: Int) -> Bool
}
