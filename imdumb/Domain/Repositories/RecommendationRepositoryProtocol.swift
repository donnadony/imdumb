protocol RecommendationRepositoryProtocol {
    func save(_ recommendation: Recommendation, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchForMovie(movieId: Int, completion: @escaping (Result<[Recommendation], Error>) -> Void)
    func fetchRecommendedMovieIds(completion: @escaping (Result<Set<Int>, Error>) -> Void)
}
