//
//  DIContainer.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

final class DIContainer {

    // MARK: - Network

    lazy var networkService: NetworkServiceProtocol = NetworkService()

    // MARK: - DataSources

    lazy var remoteDataSource: MovieDataSourceProtocol = RemoteDataSource(networkService: networkService)
    lazy var mockDataSource: MovieDataSourceProtocol = MockDataSource()

    // MARK: - Repositories

    lazy var movieRepository: MovieRepositoryProtocol = MovieRepository(
        remoteDataSource: remoteDataSource
    )

    lazy var configRepository: ConfigRepositoryProtocol = ConfigRepository(
        firebaseDataSource: FirebaseDataSource()
    )

    // MARK: - Persistence

    lazy var favoriteDataSource: FavoriteDataSourceProtocol = FavoriteDataSource(stack: .shared)

    lazy var favoriteRepository: FavoriteRepositoryProtocol = FavoriteRepository(
        dataSource: favoriteDataSource
    )

    lazy var recommendationDataSource: RecommendationDataSourceProtocol = RecommendationDataSource(stack: .shared)

    lazy var recommendationRepository: RecommendationRepositoryProtocol = RecommendationRepository(
        dataSource: recommendationDataSource
    )

    func makeFetchCategoriesUseCase() -> FetchCategoriesUseCaseProtocol {
        FetchCategoriesUseCase(repository: movieRepository)
    }

    func makeRecommendMovieUseCase() -> RecommendMovieUseCaseProtocol {
        RecommendMovieUseCase(repository: recommendationRepository)
    }
}
