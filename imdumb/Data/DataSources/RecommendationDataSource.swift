import CoreData

final class RecommendationDataSource: RecommendationDataSourceProtocol {

    private let store: CoreDataStore
    private let entityName = "RecommendationEntity"

    init(stack: CoreDataStack) {
        self.store = CoreDataStore(stack: stack)
    }

    func save(_ recommendation: Recommendation) {
        store.insert(entityName: entityName) { entity in
            entity.setValue(Int32(recommendation.movieId), forKey: "movieId")
            entity.setValue(recommendation.movieTitle, forKey: "movieTitle")
            entity.setValue(recommendation.comment, forKey: "comment")
            entity.setValue(recommendation.createdAt, forKey: "createdAt")
        }
    }

    func fetchForMovie(movieId: Int) -> [Recommendation] {
        store.fetch(
            entityName: entityName,
            predicate: NSPredicate(format: "movieId == %d", movieId),
            sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]
        ).compactMap(mapToDomain)
    }

    func fetchAllMovieIds() -> Set<Int> {
        Set(
            store.fetchDistinct(entityName: entityName, property: "movieId")
                .compactMap { ($0.value(forKey: "movieId") as? Int32).map { Int($0) } }
        )
    }

    private func mapToDomain(_ object: NSManagedObject) -> Recommendation? {
        guard let movieId = object.value(forKey: "movieId") as? Int32,
              let movieTitle = object.value(forKey: "movieTitle") as? String,
              let comment = object.value(forKey: "comment") as? String,
              let createdAt = object.value(forKey: "createdAt") as? Date else {
            return nil
        }
        return Recommendation(
            movieId: Int(movieId),
            movieTitle: movieTitle,
            comment: comment,
            createdAt: createdAt
        )
    }
}
