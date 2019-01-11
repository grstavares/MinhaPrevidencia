//
//  MockedCoreDataStack.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
@testable import MinhaPrevidencia

class MockedCoreDataStack {

    static let shared = MockedCoreDataStack()

    let context: NSManagedObjectContext
    let manager: CoreDataManager

    private init() {

        guard let modelURL = Bundle.main.url(forResource: "MinhaPrevidencia", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc

        do {
            try psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            self.context = managedObjectContext
            self.manager = CoreDataManager(context: managedObjectContext)
        } catch { fatalError("Error migrating store: \(error)") }

    }

    public func getAllItems(of entity: String) throws -> [NSManagedObject] {

        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        return try self.context.fetch(request)

    }

    public func clearEntity(entity: String) throws {

        let results = try self.getAllItems(of: entity)
        for item in results { self.context.delete(item)}
        try self.context.save()

    }

    public static func clearEntity(entity: String, context: NSManagedObjectContext) throws {

        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        let results = try context.fetch(request)
        for item in results { context.delete(item)}
        try context.save()

    }

}
