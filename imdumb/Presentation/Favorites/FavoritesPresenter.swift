import Foundation

final class FavoritesPresenter: FavoritesPresenterProtocol {

    weak var view: FavoritesViewProtocol?
    private(set) var movies: [MovieViewModel] = []
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let onMovieSelected: (Int) -> Void
    private let dispatcher: Dispatching

    init(
        favoriteRepository: FavoriteRepositoryProtocol,
        onMovieSelected: @escaping (Int) -> Void,
        dispatcher: Dispatching = DispatchQueue.main
    ) {
        self.favoriteRepository = favoriteRepository
        self.onMovieSelected = onMovieSelected
        self.dispatcher = dispatcher
    }

    func viewDidLoad() {
        loadFavorites()
    }

    func viewWillAppear() {
        loadFavorites()
    }

    func didSelectMovie(movieId: Int) {
        onMovieSelected(movieId)
    }

    func didTapFavorite(movieId: Int) {
        favoriteRepository.remove(movieId: movieId) { [weak self] result in
            self?.dispatcher.dispatch {
                guard case .success = result else { return }
                self?.loadFavorites()
            }
        }
    }

    private func loadFavorites() {
        view?.showLoading()
        favoriteRepository.fetchAll { [weak self] result in
            self?.dispatcher.dispatch {
                self?.view?.hideLoading()
                switch result {
                case .success(let items):
                    guard !items.isEmpty else {
                        self?.movies = []
                        self?.view?.showEmptyState()
                        return
                    }
                    self?.movies = items.map { MovieViewModel(favorite: $0) }
                    self?.view?.reloadData()
                case .failure:
                    self?.view?.showError(message: "Error al cargar favoritos")
                }
            }
        }
    }
}
