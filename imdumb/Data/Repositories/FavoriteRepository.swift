final class FavoriteRepository: FavoriteRepositoryProtocol {

    private let dataSource: FavoriteDataSourceProtocol

    init(dataSource: FavoriteDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func fetchAll(completion: @escaping (Result<[FavoriteMovie], Error>) -> Void) {
        completion(.success(dataSource.fetchAll()))
    }

    func add(_ movie: FavoriteMovie, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.add(movie)
        completion(.success(()))
    }

    func remove(movieId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.remove(movieId: movieId)
        completion(.success(()))
    }

    func isFavorite(movieId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(dataSource.exists(movieId: movieId)))
    }
}
