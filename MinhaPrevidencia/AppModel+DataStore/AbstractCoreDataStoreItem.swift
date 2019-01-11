//
//  AbstractCoreDataStoreItem.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData

protocol AbstractCoreDataStoreItem: CoreDataStoreItem {

    associatedtype ObjectModel: CoreDataStoreItem
    associatedtype ObjectBuilder
    associatedtype CoreDataModel: NSManagedObject

    static func parseObject(coredataObject: CoreDataModel) -> ObjectModel?

}

extension AbstractCoreDataStoreItem {

    static func loadFromDataStore<ObjectModel>(uuid: String, manager: CoreDataManager) throws -> ObjectModel? {

        guard let found: CoreDataModel = try loadManagedObject(uuid: uuid, entityName: entityName, manager: manager) else { return nil }
        guard let document = parseObject(coredataObject: found) else { return nil }
        return document as? ObjectModel

    }

    static func loadCollectionFromDataStore<ObjectModel>(predicate: NSPredicate?, manager: CoreDataManager) throws -> [ObjectModel] {

        let found: [CoreDataModel] = try loadCollectionFromDataStore(entityName: entityName, manager: manager, predicate: predicate)
        let parsed = found.compactMap { parseObject(coredataObject: $0) }
        let doubleParsed = parsed.compactMap { $0 as? ObjectModel }
        return doubleParsed

    }

    func removeFromDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            throw DataStoreError.invalidManager(expected: "CoreData", actual: manager.description)
        }

        if let first = try ObjectModel.loadManagedObject(uuid: uuid, entityName: ObjectModel.entityName, manager: coredata) {
            return coredata.remove(first)
        } else { return false }

    }

}
