//
//  FinancialEntry+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 13/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData

extension FinancialEntry: AbstractCoreDataStoreItem {

    typealias ObjectModel = FinancialEntry
//    typealias ObjectBuilder = FinancialEntryBuilder
    typealias CoreDataModel = FinancialEntryCoreData

    static var entityName: String { return "FinancialEntryCoreData" }

    static func parseObject(coredataObject: FinancialEntryCoreData) -> FinancialEntry? {

        guard let uuid = coredataObject.uuid,
            let date = coredataObject.date,
            let start = coredataObject.referenceStartDate,
            let end = coredataObject.referenceEndDate,
            let subject = coredataObject.subject
            else { return nil }

        let value = coredataObject.entryValue
        let description = coredataObject.description
        let details = coredataObject.details
        let isIncome = coredataObject.isIncome
        let entryCategory = coredataObject.entryCategory
        let wasDeleted = coredataObject.wasDeleted

        let document = ObjectModel.init(uuid: uuid, date: date, period: start...end, subject: subject, description: description, value: value, details: details, isIncome: isIncome, entryCategory: entryCategory, wasDeleted: wasDeleted)
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppDelegate.handleError(error: DataStoreError.invalidManager(expected: "CoreData", actual: manager.description))
            return false
        }

        if let first: CoreDataModel = try ObjectModel.loadManagedObject(uuid: uuid, entityName: ObjectModel.entityName, manager: coredata) {

            first.update(with: self)
            coredata.sync()
            return true

        } else {

            guard let entityDescription = NSEntityDescription.entity(forEntityName: ObjectModel.entityName, in: coredata.managedObjectContext) else {
                AppDelegate.handleError(error: DataStoreError.invalidEntity(entityName: ObjectModel.entityName))
                return false
            }

            let newObject = CoreDataModel.init(entity: entityDescription, insertInto: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.update(with: self)
            coredata.sync()
            return coredata.save(newObject)

        }

    }

}

extension FinancialEntryCoreData {

    func update(with object: FinancialEntry) {

        if self.date != object.date { self.date = object.date }
        if self.referenceStartDate != object.period.lowerBound { self.referenceStartDate = object.period.lowerBound }
        if self.referenceEndDate != object.period.upperBound { self.referenceEndDate = object.period.upperBound }
        if self.subject != object.subject { self.subject = object.subject }
        if self.entryDescription != object.description { self.entryDescription = object.description }
        if self.entryValue != object.value { self.entryValue = object.value }
        if self.details != object.details { self.details = object.details }
        if self.isIncome != object.isIncome { self.isIncome = object.isIncome }
        if self.wasDeleted != object.wasDeleted { self.wasDeleted = object.wasDeleted }

    }

}
