//
//  HomePresenter.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import Foundation

final class HomePresenter: HomePresenterProtocol {

    // MARK: - Properties

    weak var view: HomeViewProtocol?
    private(set) var featuredMovie: MovieViewModel?
    private(set) var categories: [CategoryViewModel] = []
    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol
    private let movieRepository: MovieRepositoryProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let recommendationRepository: RecommendationRepositoryProtocol
    private let onMovieSelected: (Int) -> Void
    private let localStateLoader: LocalStateLoader
    private let dispatcher: Dispatching

    private let maxCategories = 5
    private var rawCategories: [(name: String, movies: [Movie])] = []
    private var favoriteIds: Set<Int> = []
    private var recommendedIds: Set<Int> = []

    init(
        fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol,
        movieRepository: MovieRepositoryProtocol,
        favoriteRepository: FavoriteRepositoryProtocol,
        recommendationRepository: RecommendationRepositoryProtocol,
        onMovieSelected: @escaping (Int) -> Void,
        dispatcher: Dispatching = DispatchQueue.main
    ) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.movieRepository = movieRepository
        self.favoriteRepository = favoriteRepository
        self.recommendationRepository = recommendationRepository
        self.onMovieSelected = onMovieSelected
        self.localStateLoader = LocalStateLoader(favoriteRepository: favoriteRepository, recommendationRepository: recommendationRepository)
        self.dispatcher = dispatcher
    }

    // MARK: - HomePresenterProtocol

    func viewDidLoad() {
        loadCategories()
    }

    func viewWillAppear() {
        refreshLocalState()
    }

    func didSelectMovie(movieId: Int) {
        onMovieSelected(movieId)
    }

    func didPullToRefresh() {
        loadCategories()
    }

    // MARK: - Private

    private func loadCategories() {
        view?.showLoading()
        fetchCategoriesUseCase.execute { [weak self] result in
            self?.dispatcher.dispatch {
                self?.handleCategoriesResult(result)
            }
        }
    }

    private func handleCategoriesResult(_ result: Result<[Category], Error>) {
        switch result {
        case .success(let categories):
            let limited = Array(categories.prefix(maxCategories))
            guard !limited.isEmpty else {
                view?.hideLoading()
                view?.showEmptyState()
                return
            }
            fetchMoviesForCategories(limited)
        case .failure(let error):
            view?.hideLoading()
            let message = (error as? NetworkError)?.userMessage ?? "Error al cargar las categorías"
            view?.showError(message: message)
        }
    }

    private func fetchMoviesForCategories(_ categories: [Category]) {
        var results: [(name: String, movies: [Movie])] = []
        let group = DispatchGroup()

        for category in categories {
            group.enter()
            movieRepository.fetchMoviesByGenre(genreId: category.id, page: 1) { [weak self] result in
                let movies: [Movie]
                switch result {
                case .success(let movieList):
                    movies = movieList
                case .failure:
                    movies = []
                }
                self?.dispatcher.dispatch {
                    results.append((name: category.name, movies: movies))
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.rawCategories = results
            self.fetchLocalStateAndBuild(isInitialLoad: true)
        }
    }

    private func fetchLocalStateAndBuild(isInitialLoad: Bool) {
        localStateLoader.load { [weak self] snapshot in
            guard let self else { return }
            self.favoriteIds = snapshot.favoriteIds
            self.recommendedIds = snapshot.recommendedIds
            self.buildViewModels()
            if isInitialLoad {
                self.view?.hideLoading()
            }
            self.view?.reloadData()
        }
    }

    private func refreshLocalState() {
        localStateLoader.load { [weak self] snapshot in
            guard let self else { return }
            guard snapshot.favoriteIds != self.favoriteIds || snapshot.recommendedIds != self.recommendedIds else { return }
            self.favoriteIds = snapshot.favoriteIds
            self.recommendedIds = snapshot.recommendedIds
            self.buildViewModels()
            self.view?.reloadData()
        }
    }

    private func buildViewModels() {
        let nonEmpty = rawCategories.filter { !$0.movies.isEmpty }
        guard !nonEmpty.isEmpty else {
            categories = []
            featuredMovie = nil
            view?.showEmptyState()
            return
        }
        categories = nonEmpty.map { category in
            CategoryViewModel(
                id: 0,
                name: category.name,
                movies: category.movies.map {
                    MovieViewModel(movie: $0, isFavorite: favoriteIds.contains($0.id), isRecommended: recommendedIds.contains($0.id))
                }
            )
        }
        featuredMovie = categories.first?.movies.first
    }
}
