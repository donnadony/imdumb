import CoreData

final class FavoriteDataSource: FavoriteDataSourceProtocol {

    private let store: CoreDataStore
    private let entityName = "FavoriteMovieEntity"

    init(stack: CoreDataStack) {
        self.store = CoreDataStore(stack: stack)
    }

    func fetchAll() -> [FavoriteMovie] {
        store.fetch(
            entityName: entityName,
            sortDescriptors: [NSSortDescriptor(key: "addedAt", ascending: false)]
        ).compactMap(mapToDomain)
    }

    func add(_ movie: FavoriteMovie) {
        guard !exists(movieId: movie.id) else { return }
        store.insert(entityName: entityName) { entity in
            entity.setValue(Int32(movie.id), forKey: "movieId")
            entity.setValue(movie.title, forKey: "title")
            entity.setValue(movie.posterPath, forKey: "posterPath")
            entity.setValue(movie.voteAverage, forKey: "voteAverage")
            entity.setValue(movie.releaseDate, forKey: "releaseDate")
            entity.setValue(Date(), forKey: "addedAt")
        }
    }

    func remove(movieId: Int) {
        store.delete(
            entityName: entityName,
            predicate: NSPredicate(format: "movieId == %d", movieId)
        )
    }

    func exists(movieId: Int) -> Bool {
        store.count(
            entityName: entityName,
            predicate: NSPredicate(format: "movieId == %d", movieId)
        ) > 0
    }

    private func mapToDomain(_ object: NSManagedObject) -> FavoriteMovie? {
        guard let movieId = object.value(forKey: "movieId") as? Int32,
              let title = object.value(forKey: "title") as? String,
              let releaseDate = object.value(forKey: "releaseDate") as? String else {
            return nil
        }
        let voteAverage = object.value(forKey: "voteAverage") as? Double ?? 0.0
        let posterPath = object.value(forKey: "posterPath") as? String
        return FavoriteMovie(
            id: Int(movieId),
            title: title,
            posterPath: posterPath,
            voteAverage: voteAverage,
            releaseDate: releaseDate
        )
    }
}
