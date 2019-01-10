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
    typealias ObjectBuilder = CommunicationMessageBuilder
    typealias CoreDataModel = CommunicationMessageCoreData

    static var entityName: String { return "CommunicationMessageCoreData" }

    static func parseObject(coredataObject object: CoreDataModel) -> ObjectModel? {

        guard let uuid = object.uuid, let title = object.title, let content = object.content, let dateCreation = object.dateCreation, let userOrigin = object.userOrigin else { return nil }
        let summary = object.summary
        let recipientes: [String] = []  //CHANGE

        let document = ObjectBuilder.init(uuid: uuid, title: title, summary: summary, content: content, dateCreation: dateCreation, userOrigin: userOrigin, recipients: recipientes).build()
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppErrorControl.registerAppError(error: DataStoreError.invalidManager(expected: "CoreData", actual: ""))
            return false
        }

        if let first: CommunicationMessageCoreData = try CommunicationMessage.loadManagedObject(uuid: uuid, entityName: CommunicationMessage.entityName, manager: coredata) {

            first.title = self.title
            first.content = self.content
            first.dateCreation = self.dateCreation
            first.userOrigin = self.userOrigin
            //first.recipients = self.recipients
            coredata.sync()
            return true

        } else {

            let newObject = CommunicationMessageCoreData(context: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.title = self.title
            newObject.content = self.content
            newObject.dateCreation = self.dateCreation
            newObject.userOrigin = self.userOrigin
            //newObject.recipients = self.recipients
            return coredata.save(newObject)

        }

    }

    func removeFromDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppErrorControl.registerAppError(error: DataStoreError.invalidManager(expected: "CoreData", actual: ""))
            return false
        }

        if let first = try CommunicationMessage.loadManagedObject(uuid: uuid, entityName: CommunicationMessage.entityName, manager: coredata) {
            return coredata.remove(first)
        } else { return false }

    }

}
