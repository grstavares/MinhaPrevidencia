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

class CoreDataManager {

    let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {

        self.managedObjectContext = context

    }

    func request<T>(request: NSFetchRequest<T>) throws -> [T] {

        do {return try self.managedObjectContext.fetch(request)
        } catch {throw DataStoreError.unableToLoadFromContainer(type: "PLACEHOLDER", reason: error.localizedDescription)}

    }

    func loadById<T>(uuid: String, of clazz: NSManagedObject.Type) throws -> T? where T: CoreDataItem {

        do {

            let predicate = NSPredicate(format: "uuid == %@", uuid)
            let request = clazz.fetchRequest()
            request.predicate = predicate

            let context = self.managedObjectContext
            let results = try context.fetch(request)
            if let first = results.first, let coredata = first as? NSManagedObject, let parsed = T.init(fromCoreData: coredata) {return parsed
            } else {return nil}

        } catch { throw DataStoreError.unableToLoadFromContainer(type: "PLACEHOLDER", reason: error.localizedDescription) }

    }

    func create<T>(_ object: NSManagedObject) -> Observable<T?> where T: DataStoreItem & CoreDataItem {
        return Observable.of(nil)
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

    func search<T>(predicate: NSPredicate, of clazz: NSManagedObject.Type) -> Observable<[T]> where T: CoreDataItem {

        do {

            let request = clazz.fetchRequest()
            request.predicate = predicate

            let context = self.managedObjectContext
            let results = try context.fetch(request)

            var array: [T] = []
            for item in results {

                if let coredata = item as? NSManagedObject, let parsed = T.init(fromCoreData: coredata) {
                    array.append(parsed) }

            }

            return Observable.of(array)

        } catch { return Observable.error(DataStoreError.unableToLoadFromContainer(type: "PLACEHOLDER", reason: error.localizedDescription)) }

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
