import CoreData

struct CoreDataStore {

    private let stack: CoreDataStack

    init(stack: CoreDataStack) {
        self.stack = stack
    }

    func fetch(
        entityName: String,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = []
    ) -> [NSManagedObject] {
        var result: [NSManagedObject] = []
        stack.context.performAndWait {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            result = (try? stack.context.fetch(request)) ?? []
        }
        return result
    }

    func insert(entityName: String, configure: (NSManagedObject) -> Void) {
        stack.context.performAndWait {
            let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: stack.context)
            configure(entity)
        }
        stack.save()
    }

    func delete(entityName: String, predicate: NSPredicate) {
        stack.context.performAndWait {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.predicate = predicate
            let objects = (try? stack.context.fetch(request)) ?? []
            objects.forEach { stack.context.delete($0) }
        }
        stack.save()
    }

    func count(entityName: String, predicate: NSPredicate? = nil) -> Int {
        var result = 0
        stack.context.performAndWait {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.predicate = predicate
            result = (try? stack.context.count(for: request)) ?? 0
        }
        return result
    }

    func fetchDistinct(entityName: String, property: String) -> [NSManagedObject] {
        var result: [NSManagedObject] = []
        stack.context.performAndWait {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.propertiesToFetch = [property]
            request.returnsDistinctResults = true
            result = (try? stack.context.fetch(request)) ?? []
        }
        return result
    }
}
