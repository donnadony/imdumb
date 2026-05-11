//
//  DetailPresenter.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

final class DetailPresenter: DetailPresenterProtocol {

    weak var view: DetailViewProtocol?
    private(set) var imageURLs: [URL] = []
    private(set) var actors: [ActorViewModel] = []
    private(set) var isFavorite: Bool = false
    private(set) var recommendations: [RecommendationViewModel] = []
    private let movieId: Int
    private let movieRepository: MovieRepositoryProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let recommendationRepository: RecommendationRepositoryProtocol
    private let onRecommendTapped: (Movie) -> Void
    private let showRecommendationsButton: Bool
    private let dispatcher: Dispatching
    private var movie: Movie?

    private static let dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.locale = Locale(identifier: "es")
        return fmt
    }()

    init(
        movieId: Int,
        movieRepository: MovieRepositoryProtocol,
        favoriteRepository: FavoriteRepositoryProtocol,
        recommendationRepository: RecommendationRepositoryProtocol,
        showRecommendations: Bool,
        onRecommendTapped: @escaping (Movie) -> Void,
        dispatcher: Dispatching = DispatchQueue.main
    ) {
        self.movieId = movieId
        self.movieRepository = movieRepository
        self.favoriteRepository = favoriteRepository
        self.recommendationRepository = recommendationRepository
        self.showRecommendationsButton = showRecommendations
        self.onRecommendTapped = onRecommendTapped
        self.dispatcher = dispatcher
    }

    func viewDidLoad() {
        loadDetail()
        checkFavoriteStatus()
    }

    func viewWillAppear() {
        loadRecommendations()
    }

    func didTapRecommend() {
        guard let movie else { return }
        onRecommendTapped(movie)
    }

    func didTapFavorite() {
        guard let movie else { return }
        if isFavorite {
            favoriteRepository.remove(movieId: movie.id) { [weak self] result in
                self?.dispatcher.dispatch {
                    guard case .success = result else { return }
                    self?.isFavorite = false
                    self?.view?.updateFavoriteButton(isFavorite: false)
                }
            }
        } else {
            let favorite = FavoriteMovie(
                id: movie.id,
                title: movie.title,
                posterPath: movie.posterPath,
                voteAverage: movie.voteAverage,
                releaseDate: movie.releaseDate
            )
            favoriteRepository.add(favorite) { [weak self] result in
                self?.dispatcher.dispatch {
                    guard case .success = result else { return }
                    self?.isFavorite = true
                    self?.view?.updateFavoriteButton(isFavorite: true)
                }
            }
        }
    }

    private func checkFavoriteStatus() {
        favoriteRepository.isFavorite(movieId: movieId) { [weak self] result in
            self?.dispatcher.dispatch {
                if case .success(let value) = result {
                    self?.isFavorite = value
                    self?.view?.updateFavoriteButton(isFavorite: value)
                }
            }
        }
    }

    private func loadRecommendations() {
        recommendationRepository.fetchForMovie(movieId: movieId) { [weak self] result in
            self?.dispatcher.dispatch {
                guard let self, case .success(let items) = result else { return }
                self.recommendations = items.map { rec in
                    RecommendationViewModel(
                        comment: rec.comment,
                        date: Self.dateFormatter.string(from: rec.createdAt)
                    )
                }
                self.view?.showRecommendations(self.recommendations)
            }
        }
    }

    private func loadDetail() {
        view?.showLoading()
        movieRepository.fetchMovieDetail(movieId: movieId) { [weak self] result in
            self?.dispatcher.dispatch {
                self?.handleDetailResult(result)
            }
        }
    }

    private func handleDetailResult(_ result: Result<Movie, Error>) {
        view?.hideLoading()
        switch result {
        case .success(let movie):
            self.movie = movie
            let viewModel = mapToViewModel(movie)
            self.imageURLs = viewModel.imageURLs
            self.actors = viewModel.actors
            view?.showDetail(viewModel)
            view?.configureRecommendButton(visible: showRecommendationsButton)
        case .failure(let error):
            let message = (error as? NetworkError)?.userMessage ?? "No se pudo cargar el detalle"
            view?.showError(message: message)
        }
    }

    private func mapToViewModel(_ movie: Movie) -> DetailViewModel {
        var imageURLs: [URL] = []
        if let url = APIConstants.imageURL(from: movie.backdropPath) {
            imageURLs.append(url)
        }
        for img in movie.images {
            if let url = APIConstants.imageURL(from: img.filePath) {
                imageURLs.append(url)
            }
        }
        if imageURLs.isEmpty, let url = APIConstants.imageURL(from: movie.posterPath) {
            imageURLs.append(url)
        }

        let actors = movie.cast.map { actor in
            ActorViewModel(
                name: actor.name,
                character: actor.character,
                photoURL: APIConstants.imageURL(from: actor.profilePath)
            )
        }

        let runtime: String
        if let mins = movie.runtime, mins > 0 {
            runtime = "\(mins / 60)h \(mins % 60)m"
        } else {
            runtime = ""
        }

        let genres = movie.genres.map { $0.name }.joined(separator: " · ")

        return DetailViewModel(
            title: movie.title,
            overview: movie.overview,
            rating: String(format: "%.1f", movie.voteAverage),
            ratingValue: movie.voteAverage,
            releaseDate: String(movie.releaseDate.prefix(4)),
            runtime: runtime,
            genres: genres,
            imageURLs: imageURLs,
            actors: actors
        )
    }
}
