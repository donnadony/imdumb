//
//  DetailProtocols.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showDetail(_ viewModel: DetailViewModel)
    func showError(message: String)
    func configureRecommendButton(visible: Bool)
    func updateFavoriteButton(isFavorite: Bool)
    func showRecommendations(_ recommendations: [RecommendationViewModel])
}

protocol DetailPresenterProtocol: AnyObject {
    var imageURLs: [URL] { get }
    var actors: [ActorViewModel] { get }
    var isFavorite: Bool { get }
    var recommendations: [RecommendationViewModel] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didTapRecommend()
    func didTapFavorite()
}

struct DetailViewModel {
    let title: String
    let overview: String
    let rating: String
    let ratingValue: Double
    let releaseDate: String
    let runtime: String
    let genres: String
    let imageURLs: [URL]
    let actors: [ActorViewModel]
}

struct ActorViewModel {
    let name: String
    let character: String
    let photoURL: URL?
}

struct RecommendationViewModel {
    let comment: String
    let date: String
}
