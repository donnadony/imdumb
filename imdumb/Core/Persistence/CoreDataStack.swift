//
//  CoreDataStack.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    private init() {}

    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IMDUMB")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func save() {
        context.performAndWait {
            guard context.hasChanges else { return }
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }
}
