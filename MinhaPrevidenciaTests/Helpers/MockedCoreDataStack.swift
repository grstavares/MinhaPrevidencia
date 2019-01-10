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

    let context: NSManagedObjectContext
    let manager: CoreDataManager

    init() {

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

}
