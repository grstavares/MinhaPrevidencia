//
//  NewsReport+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit

extension NewsReport: AbstractCoreDataStoreItem {

    typealias ObjectModel = NewsReport
    typealias ObjectBuilder = NewsReportBuilder
    typealias CoreDataModel = NewsReportCoreData

    static var entityName: String { return "NewsReportCoreData" }

    static func parseObject(coredataObject object: CoreDataModel) -> ObjectModel? {

        guard let uuid = object.uuid, let title = object.title, let contents = object.contents, let dateCreation = object.dateCreation, let lasUpdate = object.lastUpdate, let url = object.url else { return nil }

        let document = ObjectBuilder.init(uuid: uuid, title: title, contents: contents, dateCreation: dateCreation, lastUpdate: lasUpdate, url: url).build()
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppErrorControl.registerAppError(error: DataStoreError.invalidManager(expected: "CoreData", actual: ""))
            return false
        }

        if let first: NewsReportCoreData = try NewsReport.loadManagedObject(uuid: uuid, entityName: NewsReport.entityName, manager: coredata) {

            first.title = self.title
            first.contents = self.contents
            first.dateCreation = self.dateCreation
            first.lastUpdate = self.lastUpdate
            first.url = self.url
            coredata.sync()
            return true

        } else {

            let newObject = NewsReportCoreData(context: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.title = self.title
            newObject.contents = self.contents
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

        if let first = try NewsReport.loadManagedObject(uuid: uuid, entityName: NewsReport.entityName, manager: coredata) {
            return coredata.remove(first) } else { return false }

    }

}
