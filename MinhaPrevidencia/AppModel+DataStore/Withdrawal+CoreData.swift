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
    typealias ObjectBuilder = WithdrawalBuilder
    typealias CoreDataModel = WithdrawalCoreData

    static var entityName: String { return "WithdrawalCoreData" }

    static func parseObject(coredataObject: CoreDataModel) -> ObjectModel? {

        guard let uuid = coredataObject.uuid, let date = coredataObject.date, let reference = coredataObject.reference else { return nil }
        let value = coredataObject.value

        let document = ObjectBuilder.init(uuid: uuid, date: date, value: value, reference: reference).build()
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppErrorControl.registerAppError(error: DataStoreError.invalidManager(expected: "CoreData", actual: ""))
            return false
        }

        if let first: WithdrawalCoreData = try Withdrawal.loadManagedObject(uuid: uuid, entityName: Withdrawal.entityName, manager: coredata) {

            first.date = self.date
            first.reference = self.reference
            first.value = self.value
            coredata.sync()
            return true

        } else {

            let newObject = WithdrawalCoreData(context: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.date = self.date
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

        if let first = try Withdrawal.loadManagedObject(uuid: uuid, entityName: Withdrawal.entityName, manager: coredata) {
            return coredata.remove(first)
        } else { return false }

    }

}
