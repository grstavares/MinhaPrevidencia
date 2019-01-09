//
//  Institution+DataStoreItem.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 09/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData

extension Institution: DataStoreItem {

    static func loadFromDataStore<Institution>(uuid: String, manager: CoreDataManager) throws -> Institution? {

        let arrayOfCoreDataObjects: [InstitutionCoreData] = try loadManagedObject(uuid: uuid, manager: manager)

        if let first = arrayOfCoreDataObjects.first {                              // MustBeUnique

            if let uuid = first.uuid, let name = first.name {
                return InstitutionBuilder(uuid: uuid, name: name).build() as? Institution
            } else { throw DataStoreError.unableToParseObject(type: "Institution", reason: "PLACEHOLDER") }

        } else {return nil}

    }

    func saveInDataStore(manager: CoreDataManager) throws -> Bool {

        let arrayOfCoreDataObjects: [InstitutionCoreData] = try Institution.loadManagedObject(uuid: uuid, manager: manager)

        if let first = arrayOfCoreDataObjects.first {
            first.name = self.name
            manager.sync()
            return true
        } else {

            let newObject = InstitutionCoreData(context: manager.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.name = self.name
            return manager.save(newObject)

        }

    }

    func removeFromDataStore(manager: CoreDataManager) throws -> Bool {

        let arrayOfCoreDataObjects: [InstitutionCoreData] = try Institution.loadManagedObject(uuid: uuid, manager: manager)
        if let first = arrayOfCoreDataObjects.first { return manager.remove(first) } else { return false }

    }

    private static func loadManagedObject(uuid: String, manager: CoreDataManager) throws -> [InstitutionCoreData] {

        //        guard let coredata = manager as? CoreDataManager else { throw DataStoreError.invalidManager(expected: "CoreData", actual: "NONE") }

        let predicate = NSPredicate(format: "uuid == %@", uuid)
        let request = NSFetchRequest<InstitutionCoreData>(entityName: "InstitutionCoreData")
        request.predicate = predicate

        //        let results = try coredata.request(request: request)
        let results = try manager.request(request: request)
        return results

    }

}
