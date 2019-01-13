//
//  Institution+DataStoreItem.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 09/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit

extension Institution: AbstractCoreDataStoreItem {

    typealias ObjectModel = Institution
//    typealias ObjectBuilder = InstitutionBuilder
    typealias CoreDataModel = InstitutionCoreData

    static var entityName: String { return "InstitutionCoreData" }

    static func parseObject(coredataObject: CoreDataModel) -> ObjectModel? {

        guard let uuid = coredataObject.uuid, let name = coredataObject.name else { return nil }
        let wasDeleted = coredataObject.wasDeleted

        let document = ObjectModel.init(uuid: uuid, name: name, wasDeleted: wasDeleted)
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppDelegate.handleError(error: DataStoreError.invalidManager(expected: "CoreData", actual: manager.description))
            return false
        }

        if let first: InstitutionCoreData = try Institution.loadManagedObject(uuid: uuid, entityName: Institution.entityName, manager: coredata) {
            first.name = self.name
            coredata.sync()
            return true
        } else {

            guard let entityDescription = NSEntityDescription.entity(forEntityName: ObjectModel.entityName, in: coredata.managedObjectContext) else {
                AppDelegate.handleError(error: DataStoreError.invalidEntity(entityName: ObjectModel.entityName))
                return false
            }

            let newObject = CoreDataModel.init(entity: entityDescription, insertInto: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.name = self.name
            return coredata.save(newObject)

        }

    }

}
