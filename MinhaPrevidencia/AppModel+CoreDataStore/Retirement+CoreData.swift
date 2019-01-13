//
//  Retirement+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit

extension Retirement: AbstractCoreDataStoreItem {

    typealias ObjectModel = Retirement
//    typealias ObjectBuilder = RetirementBuilder
    typealias CoreDataModel = RetirementCoreData

    static var entityName: String { return "RetirementCoreData" }

    static func parseObject(coredataObject: CoreDataModel) -> ObjectModel? {

        guard let uuid = coredataObject.uuid, let startDate = coredataObject.startDate, let endDate = coredataObject.endDate else { return nil }
        let contr: [Contribution] = getContributions(coredataSet: coredataObject.contributions)
        let withd: [Withdrawal] = getWithdrawals(coredataSet: coredataObject.withdrawals)
        let wasDeleted = coredataObject.wasDeleted

        let document = ObjectModel.init(uuid: uuid, startDate: startDate, endDate: endDate, contributions: contr, withdrawals: withd, wasDeleted: wasDeleted)
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppDelegate.handleError(error: DataStoreError.invalidManager(expected: "CoreData", actual: manager.description))
            return false
        }

        let setOfContributions = try parseContributions(manager: coredata)
        let setOfWithdrawals = try parseWithDrawals(manager: coredata)

        if let first: RetirementCoreData = try Retirement.loadManagedObject(uuid: uuid, entityName: Retirement.entityName, manager: coredata) {

            first.startDate = self.startDate
            first.endDate = self.endDate
            first.contributions = NSSet(set: setOfContributions)
            first.withdrawals = NSSet(set: setOfWithdrawals)
            coredata.sync()
            return true

        } else {

            guard let entityDescription = NSEntityDescription.entity(forEntityName: ObjectModel.entityName, in: coredata.managedObjectContext) else {
                AppDelegate.handleError(error: DataStoreError.invalidEntity(entityName: ObjectModel.entityName))
                return false
            }

            let newObject = CoreDataModel.init(entity: entityDescription, insertInto: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.startDate = self.startDate
            newObject.endDate = self.endDate
            newObject.contributions = NSSet(set: setOfContributions)
            newObject.withdrawals = NSSet(set: setOfWithdrawals)
            return coredata.save(newObject)

        }

    }

    func parseContributions(manager: CoreDataManager) throws -> Set<ContributionCoreData> {

        let arrayOfContributions: [ContributionCoreData] = try self.contributions.compactMap {

            if let found: ContributionCoreData = try Contribution.loadManagedObject(uuid: $0.uuid, entityName: Contribution.entityName, manager: manager) { return found
            } else {

                do {

                    _ = try $0.saveInDataStore(manager: manager)
                    if let foundAfterCreation: ContributionCoreData = try Contribution.loadManagedObject(uuid: $0.uuid, entityName: "", manager: manager) {
                        return foundAfterCreation
                    } else { throw DataStoreError.unableToSaveInContainer(type: "Contribution", reason: "NotFound After Creation") }

                } catch let coredataError { throw DataStoreError.unableToSaveInContainer(type: "Contribution", reason: coredataError.localizedDescription) }

            }

        }

        return Set(arrayOfContributions)

    }

    func parseWithDrawals(manager: CoreDataManager) throws -> Set<WithdrawalCoreData> {

        let arrayOfWithdrawals: [WithdrawalCoreData] = try self.withdrawals.compactMap {

            if let found: WithdrawalCoreData = try Withdrawal.loadManagedObject(uuid: $0.uuid, entityName: Withdrawal.entityName, manager: manager) { return found
            } else {

                do {

                    _ = try $0.saveInDataStore(manager: manager)
                    if let foundAfterCreation: WithdrawalCoreData = try Withdrawal.loadManagedObject(uuid: $0.uuid, entityName: "", manager: manager) {
                        return foundAfterCreation
                    } else { throw DataStoreError.unableToSaveInContainer(type: "Withdrawal", reason: "NotFound After Creation") }

                } catch let coredataError { throw DataStoreError.unableToSaveInContainer(type: "Withdrawal", reason: coredataError.localizedDescription) }

            }

        }

        return Set(arrayOfWithdrawals)

    }

    static private func getContributions(coredataSet: NSSet?) -> [Contribution.ObjectModel] {

        guard let set = coredataSet else { return [] }

        return set.allObjects
        .compactMap { $0 as? Contribution.CoreDataModel }
        .compactMap { Contribution.parseObject(coredataObject: $0) }

    }

    static private func getWithdrawals(coredataSet: NSSet?) -> [Withdrawal.ObjectModel] {

        guard let set = coredataSet else { return [] }

        return set.allObjects
            .compactMap { $0 as? Withdrawal.CoreDataModel }
            .compactMap { Withdrawal.parseObject(coredataObject: $0) }

    }

}
