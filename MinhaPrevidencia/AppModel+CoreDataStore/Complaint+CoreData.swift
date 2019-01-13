//
//  Complaint+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit

extension Complaint: AbstractCoreDataStoreItem {

    typealias ObjectModel = Complaint
//    typealias ObjectBuilder = ComplaintBuilder
    typealias CoreDataModel = ComplaintCoreData

    static var entityName: String { return "ComplaintCoreData" }

    static func parseObject(coredataObject object: CoreDataModel) -> ObjectModel? {

        guard let uuid = object.uuid, let title = object.title, let content = object.content, let dateCreation = object.dateCreation, let status = object.status else { return nil }
        guard let parsedStatus = Complaint.Status(rawValue: status) else { return nil }
        let dateReception = object.dateReception
        let wasDeleted = object.wasDeleted

        let document = ObjectModel.init(uuid: uuid, title: title, content: content, dateCreation: dateCreation, dateReception: dateReception, status: parsedStatus, wasDeleted: wasDeleted)
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppDelegate.handleError(error: DataStoreError.invalidManager(expected: "CoreData", actual: manager.description))
            return false
        }

        if let first: ComplaintCoreData = try Complaint.loadManagedObject(uuid: uuid, entityName: Complaint.entityName, manager: coredata) {

            first.title = self.title
            first.content = self.content
            first.dateCreation = self.dateCreation
            first.dateReception = self.dateReception
            first.status = self.status.rawValue
            coredata.sync()
            return true

        } else {

            guard let entityDescription = NSEntityDescription.entity(forEntityName: ObjectModel.entityName, in: coredata.managedObjectContext) else {
                AppDelegate.handleError(error: DataStoreError.invalidEntity(entityName: ObjectModel.entityName))
                return false
            }

            let newObject = CoreDataModel.init(entity: entityDescription, insertInto: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.title = self.title
            newObject.content = self.content
            newObject.dateCreation = self.dateCreation
            newObject.dateReception = self.dateReception
            newObject.status = self.status.rawValue
            return coredata.save(newObject)

        }

    }

}
