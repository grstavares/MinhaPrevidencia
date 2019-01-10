//
//  Document+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit

extension Document: AbstractCoreDataStoreItem {

    typealias ObjectModel = Document
    typealias ObjectBuilder = DocumentBuilder
    typealias CoreDataModel = DocumentCoreData

    static var entityName: String { return "DocumentCoreData" }

    static func parseObject(coredataObject object: CoreDataModel) -> ObjectModel? {

        guard let uuid = object.uuid, let title = object.title, let summary = object.summary, let dateCreation = object.dateCreation, let url = object.url else { return nil }
        let lasUpdate = object.lastUpdate

        let document = ObjectBuilder.init(uuid: uuid, title: title, summary: summary, dateCreation: dateCreation, lastUpdate: lasUpdate, url: url).build()
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppErrorControl.registerAppError(error: DataStoreError.invalidManager(expected: "CoreData", actual: ""))
            return false
        }

        if let first: DocumentCoreData = try Document.loadManagedObject(uuid: uuid, entityName: Document.entityName, manager: coredata) {

            first.title = self.title
            first.summary = self.summary
            first.dateCreation = self.dateCreation
            first.lastUpdate = self.lastUpdate
            first.url = self.url
            coredata.sync()
            return true

        } else {

            let newObject = DocumentCoreData(context: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.title = self.title
            newObject.summary = self.summary
            newObject.dateCreation = self.dateCreation
            newObject.lastUpdate = self.lastUpdate
            newObject.url = self.url
            return coredata.save(newObject)

        }

    }

    func removeFromDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppErrorControl.registerAppError(error: DataStoreError.invalidManager(expected: "CoreData", actual: ""))
            return false
        }

        if let first = try Document.loadManagedObject(uuid: uuid, entityName: Document.entityName, manager: coredata) {
            return coredata.remove(first) } else { return false }

    }

}
