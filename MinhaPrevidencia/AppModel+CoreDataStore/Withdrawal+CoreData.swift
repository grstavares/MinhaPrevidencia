//
//  Withdrawal+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit

extension Withdrawal: AbstractCoreDataStoreItem {

    typealias ObjectModel = Withdrawal
//    typealias ObjectBuilder = WithdrawalBuilder
    typealias CoreDataModel = WithdrawalCoreData

    static var entityName: String { return "WithdrawalCoreData" }

    static func parseObject(coredataObject: CoreDataModel) -> ObjectModel? {

        guard let uuid = coredataObject.uuid, let date = coredataObject.date, let reference = coredataObject.reference else { return nil }
        let value = coredataObject.value
        let wasDeleted = coredataObject.wasDeleted

        let document = ObjectModel.init(uuid: uuid, date: date, value: value, reference: reference, wasDeleted: wasDeleted)
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppDelegate.handleError(error: DataStoreError.invalidManager(expected: "CoreData", actual: manager.description))
            return false
        }

        if let first: WithdrawalCoreData = try Withdrawal.loadManagedObject(uuid: uuid, entityName: Withdrawal.entityName, manager: coredata) {

            first.date = self.date
            first.reference = self.reference
            first.value = self.value
            coredata.sync()
            return true

        } else {

            guard let entityDescription = NSEntityDescription.entity(forEntityName: ObjectModel.entityName, in: coredata.managedObjectContext) else {
                AppDelegate.handleError(error: DataStoreError.invalidEntity(entityName: ObjectModel.entityName))
                return false
            }

            let newObject = CoreDataModel.init(entity: entityDescription, insertInto: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.date = self.date
            newObject.reference = self.reference
            newObject.value = self.value
            return coredata.save(newObject)

        }

    }

}
