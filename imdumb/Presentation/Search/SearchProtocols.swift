//
//  SearchProtocols.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
    func showEmptyState()
    func showInitialState()
}

protocol SearchPresenterProtocol {
    var topMatch: TopMatchViewModel? { get }
    var movies: [MovieViewModel] { get }
    func didChangeQuery(_ query: String)
    func didSelectMovie(movieId: Int)
    func didClearSearch()
}

struct TopMatchViewModel {
    let id: Int
    let title: String
    let posterURL: URL?
    let rating: String
    let year: String
    let genres: String
    let overview: String
}
