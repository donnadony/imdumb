final class RecommendationRepository: RecommendationRepositoryProtocol {

    private let dataSource: RecommendationDataSourceProtocol

    init(dataSource: RecommendationDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func save(_ recommendation: Recommendation, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.save(recommendation)
        completion(.success(()))
    }

    func fetchForMovie(movieId: Int, completion: @escaping (Result<[Recommendation], Error>) -> Void) {
        let results = dataSource.fetchForMovie(movieId: movieId)
        completion(.success(results))
    }

    func fetchRecommendedMovieIds(completion: @escaping (Result<Set<Int>, Error>) -> Void) {
        let ids = dataSource.fetchAllMovieIds()
        completion(.success(ids))
    }
}
