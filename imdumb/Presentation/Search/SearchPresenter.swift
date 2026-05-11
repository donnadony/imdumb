//
//  SearchPresenter.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

final class SearchPresenter: SearchPresenterProtocol {

    weak var view: SearchViewProtocol?
    private(set) var topMatch: TopMatchViewModel?
    private(set) var movies: [MovieViewModel] = []
    private let movieRepository: MovieRepositoryProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let recommendationRepository: RecommendationRepositoryProtocol
    private let onMovieSelected: (Int) -> Void
    private let localStateLoader: LocalStateLoader
    private let dispatcher: Dispatching
    private var debounceTimer: Timer?
    private let debounceInterval: TimeInterval = 0.4
    private var favoriteIds: Set<Int> = []
    private var recommendedIds: Set<Int> = []

    init(
        movieRepository: MovieRepositoryProtocol,
        favoriteRepository: FavoriteRepositoryProtocol,
        recommendationRepository: RecommendationRepositoryProtocol,
        onMovieSelected: @escaping (Int) -> Void,
        dispatcher: Dispatching = DispatchQueue.main
    ) {
        self.movieRepository = movieRepository
        self.favoriteRepository = favoriteRepository
        self.recommendationRepository = recommendationRepository
        self.onMovieSelected = onMovieSelected
        self.localStateLoader = LocalStateLoader(favoriteRepository: favoriteRepository, recommendationRepository: recommendationRepository)
        self.dispatcher = dispatcher
    }

    // MARK: - SearchPresenterProtocol

    // TODO: extract pagination state so we can load more results on scroll
    func didChangeQuery(_ query: String) {
        debounceTimer?.invalidate()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            topMatch = nil
            movies = []
            view?.showInitialState()
            return
        }
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { [weak self] _ in
            self?.performSearch(trimmed)
        }
    }

    func didSelectMovie(movieId: Int) {
        onMovieSelected(movieId)
    }

    func didClearSearch() {
        debounceTimer?.invalidate()
        topMatch = nil
        movies = []
        view?.showInitialState()
    }

    private func performSearch(_ query: String) {
        view?.showLoading()
        loadLocalState { [weak self] in
            self?.movieRepository.searchMovies(query: query, page: 1) { [weak self] result in
                self?.dispatcher.dispatch {
                    self?.handleResult(result)
                }
            }
        }
    }

    private func loadLocalState(completion: @escaping () -> Void) {
        localStateLoader.load { [weak self] snapshot in
            self?.favoriteIds = snapshot.favoriteIds
            self?.recommendedIds = snapshot.recommendedIds
            completion()
        }
    }

    private func handleResult(_ result: Result<[Movie], Error>) {
        view?.hideLoading()
        switch result {
        case .success(let movieList):
            guard !movieList.isEmpty else {
                topMatch = nil
                movies = []
                view?.showEmptyState()
                return
            }
            topMatch = mapTopMatch(movieList[0])
            movies = Array(movieList.dropFirst()).map {
                MovieViewModel(movie: $0, isFavorite: favoriteIds.contains($0.id), isRecommended: recommendedIds.contains($0.id))
            }
            view?.reloadData()
        case .failure(let error):
            let message = (error as? NetworkError)?.userMessage ?? "Ocurrió un error en la búsqueda"
            view?.showError(message: message)
        }
    }

    private func mapTopMatch(_ movie: Movie) -> TopMatchViewModel {
        let posterURL = APIConstants.imageURL(from: movie.posterPath)
        let genres = movie.genres.map { $0.name }.joined(separator: ", ")
        return TopMatchViewModel(
            id: movie.id,
            title: movie.title,
            posterURL: posterURL,
            rating: String(format: "%.1f", movie.voteAverage),
            year: String(movie.releaseDate.prefix(4)),
            genres: genres,
            overview: movie.overview
        )
    }

}
