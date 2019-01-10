//
//  CoreDataStoreItem.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStoreItem: DataStoreItem {

    static func loadCollectionFromDataStore<T: NSManagedObject>(entityName: String, manager: CoreDataManager, predicate: NSPredicate?) throws -> [T]
    static func loadManagedObject<T: NSManagedObject>(uuid: String, entityName: String, manager: CoreDataManager) throws -> T?

}

extension CoreDataStoreItem {

    static func loadCollectionFromDataStore<T: NSManagedObject>(entityName: String, manager: CoreDataManager, predicate: NSPredicate?) throws -> [T] {

        //        guard let coredata = manager as? CoreDataManager else { throw DataStoreError.invalidManager(expected: "CoreData", actual: "NONE") }

        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = predicate

        //        let results = try coredata.request(request: request)
        let results = try manager.request(request: request)
        return results

    }

    static func loadManagedObject<T: NSManagedObject>(uuid: String, entityName: String, manager: CoreDataManager) throws -> T? {

        let predicate = NSPredicate(format: "uuid == %@", uuid)
        return try loadCollectionFromDataStore(entityName: entityName, manager: manager, predicate: predicate).first

    }

}
