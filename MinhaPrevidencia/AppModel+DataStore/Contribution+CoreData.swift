//
//  Contribution+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit

extension Contribution: AbstractCoreDataStoreItem {

    typealias ObjectModel = Contribution
    typealias ObjectBuilder = ContributionBuilder
    typealias CoreDataModel = ContributionCoreData

    static var entityName: String { return "ContributionCoreData" }

    static func parseObject(coredataObject object: CoreDataModel) -> ObjectModel? {

        guard let uuid = object.uuid, let source = object.source, let refer = object.reference else { return nil }
        let value = object.value

        let document = ObjectBuilder.init(uuid: uuid, source: source, reference: refer, value: value).build()
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppErrorControl.registerAppError(error: DataStoreError.invalidManager(expected: "CoreData", actual: ""))
            return false
        }

        if let first: ContributionCoreData = try Contribution.loadManagedObject(uuid: uuid, entityName: Contribution.entityName, manager: coredata) {

            first.source = self.source
            first.reference = self.reference
            first.value = self.value
            coredata.sync()
            return true

        } else {

            let newObject = ContributionCoreData(context: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.source = self.source
            newObject.reference = self.reference
            newObject.value = self.value
            return coredata.save(newObject)

        }

    }

    func removeFromDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppErrorControl.registerAppError(error: DataStoreError.invalidManager(expected: "CoreData", actual: ""))
            return false
        }

        if let first = try Contribution.loadManagedObject(uuid: uuid, entityName: Contribution.entityName, manager: coredata) {
            return coredata.remove(first)
        } else { return false }

    }

}
