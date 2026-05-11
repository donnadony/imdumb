protocol FavoritesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showEmptyState()
    func showError(message: String)
}

protocol FavoritesPresenterProtocol {
    var movies: [MovieViewModel] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didSelectMovie(movieId: Int)
    func didTapFavorite(movieId: Int)
}
