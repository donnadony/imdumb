//
//  HomeProtocols.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
    func showEmptyState()
}

protocol HomePresenterProtocol {
    var featuredMovie: MovieViewModel? { get }
    var categories: [CategoryViewModel] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didSelectMovie(movieId: Int)
    func didPullToRefresh()
}

struct CategoryViewModel {

    let id: Int
    let name: String
    let movies: [MovieViewModel]
}

struct MovieViewModel {

    let id: Int
    let title: String
    let posterURL: URL?
    let rating: String
    let year: String
    var isFavorite: Bool = false
    var isRecommended: Bool = false

    init(movie: Movie, isFavorite: Bool = false, isRecommended: Bool = false) {
        self.id = movie.id
        self.title = movie.title
        self.posterURL = APIConstants.imageURL(from: movie.posterPath)
        self.rating = String(format: "%.1f", movie.voteAverage)
        self.year = String(movie.releaseDate.prefix(4))
        self.isFavorite = isFavorite
        self.isRecommended = isRecommended
    }

    init(favorite: FavoriteMovie) {
        self.id = favorite.id
        self.title = favorite.title
        self.posterURL = APIConstants.imageURL(from: favorite.posterPath)
        self.rating = String(format: "%.1f", favorite.voteAverage)
        self.year = String(favorite.releaseDate.prefix(4))
        self.isFavorite = true
        self.isRecommended = false
    }
}
