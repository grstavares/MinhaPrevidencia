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

    let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {

        self.managedObjectContext = context

    }

    func request<T>(request: NSFetchRequest<T>) throws -> [T] {

        do {return try self.managedObjectContext.fetch(request)
        } catch {throw DataStoreError.unableToLoadFromContainer(type: "PLACEHOLDER", reason: error.localizedDescription)}

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
            let coredataError = DataStoreError.unableToSaveInContainer(type: context.description, reason: error.localizedDescription)
            AppErrorControl.registerAppError(error: coredataError)
        }

    }

}
