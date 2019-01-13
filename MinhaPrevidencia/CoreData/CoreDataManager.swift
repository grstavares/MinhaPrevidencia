//
//  CoreDataManager.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 09/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import SwiftSugarKit

class CoreDataManager: DataStoreManager {

    var description: String {

        guard let stores = managedObjectContext.persistentStoreCoordinator?.persistentStores else { return "NoPersisteStoreLocated" }
        var description: String = ""
        for (index, item) in stores.enumerated() {description.append(contentsOf: "\(index) - \(item.type)")}
        return description

    }

    let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {

        self.managedObjectContext = context

    }

    func request<T>(request: NSFetchRequest<T>) throws -> [T] {

        do {return try self.managedObjectContext.fetch(request)
        } catch {throw DataStoreError.unableToLoadFromContainer(type: self.description, reason: error.localizedDescription)}

    }

    func save(_ object: NSManagedObject) -> Bool {
        self.sync()
        return true
    }

    func remove(_ object: NSManagedObject) -> Bool {
        self.managedObjectContext.delete(object)
        self.sync()
        return true
    }

    func sync() {

        let context = self.managedObjectContext
        if !context.hasChanges { return }
        do { try context.save()
        } catch {
            let storeType = context.persistentStoreCoordinator?.persistentStores.first?.type ?? "Undefined"
            let coredataError = DataStoreError.unableToSaveInContainer(type: storeType, reason: error.localizedDescription)
            AppDelegate.handleError(error: coredataError)
        }

    }

}
