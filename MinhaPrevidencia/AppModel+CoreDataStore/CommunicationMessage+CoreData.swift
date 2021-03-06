//
//  CommunicationMessage+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit
import SwiftSugarKit

extension CommunicationMessage: AbstractCoreDataStoreItem {

    typealias ObjectModel = CommunicationMessage
//    typealias ObjectBuilder = CommunicationMessageBuilder
    typealias CoreDataModel = CommunicationMessageCoreData

    static var entityName: String { return "CommunicationMessageCoreData" }

    static func parseObject(coredataObject object: CoreDataModel) -> ObjectModel? {

        guard let uuid = object.uuid, let title = object.title, let content = object.content, let dateCreation = object.dateCreation, let userOrigin = object.userOrigin else { return nil }
        let summary = object.summary
        let recipientes: [String] = []  //CHANGE (WORK WITH TRANSFORMABLE)
        let wasDeleted = object.wasDeleted

        let document = ObjectModel.init(uuid: uuid, title: title, summary: summary, content: content, dateCreation: dateCreation, userOrigin: userOrigin, recipients: recipientes, wasDeleted: wasDeleted)
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppDelegate.handleError(error: DataStoreError.invalidManager(expected: "CoreData", actual: manager.description))
            return false
        }

        if let first: CommunicationMessageCoreData = try CommunicationMessage.loadManagedObject(uuid: uuid, entityName: CommunicationMessage.entityName, manager: coredata) {

            first.title = self.title
            first.content = self.content
            first.dateCreation = self.dateCreation
            first.userOrigin = self.userOrigin
            first.wasDeleted = self.wasDeleted
            //first.recipients = self.recipients
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
            newObject.userOrigin = self.userOrigin
            //newObject.recipients = self.recipients
            newObject.wasDeleted = self.wasDeleted
            return coredata.save(newObject)

        }

    }

}
