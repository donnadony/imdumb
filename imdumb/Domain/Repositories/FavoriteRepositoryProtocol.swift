protocol FavoriteRepositoryProtocol {
    func fetchAll(completion: @escaping (Result<[FavoriteMovie], Error>) -> Void)
    func add(_ movie: FavoriteMovie, completion: @escaping (Result<Void, Error>) -> Void)
    func remove(movieId: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func isFavorite(movieId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}
