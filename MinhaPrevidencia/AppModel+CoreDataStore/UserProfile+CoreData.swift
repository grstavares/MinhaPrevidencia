//
//  UserProfile+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import SwiftSugarKit

extension UserProfile: AbstractCoreDataStoreItem {

    typealias ObjectModel = UserProfile
//    typealias ObjectBuilder = UserProfileBuilder
    typealias CoreDataModel = UserProfileCoreData

    static var entityName: String { return "UserProfileCoreData" }

    static func parseObject(coredataObject: CoreDataModel) -> ObjectModel? {

        guard let uuid = coredataObject.uuid, let firstname = coredataObject.firstName, let lastname = coredataObject.lastName else { return nil }
        let username = coredataObject.username
        let phone = coredataObject.phoneNumber
        let wasDeleted = coredataObject.wasDeleted

        let document = ObjectModel(uuid: uuid, firstName: firstname, lastName: lastname, username: username, phoneNumber: phone, birthDate: coredataObject.birthDate, genre: coredataObject.genre, wasDeleted: wasDeleted)
        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            AppDelegate.handleError(error: DataStoreError.invalidManager(expected: "CoreData", actual: manager.description))
            return false
        }

        if let first: UserProfileCoreData = try UserProfile.loadManagedObject(uuid: uuid, entityName: UserProfile.entityName, manager: coredata) {

            first.firstName = self.firstName
            first.lastName = self.lastName
            first.username = self.username
            first.birthDate = self.birthDate
            first.genre = self.genre
            coredata.sync()
            return true

        } else {

            guard let entityDescription = NSEntityDescription.entity(forEntityName: ObjectModel.entityName, in: coredata.managedObjectContext) else {
                AppDelegate.handleError(error: DataStoreError.invalidEntity(entityName: ObjectModel.entityName))
                return false
            }

            let newObject = CoreDataModel.init(entity: entityDescription, insertInto: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.firstName = self.firstName
            newObject.lastName = self.lastName
            newObject.username = self.username
            newObject.birthDate = self.birthDate
            newObject.genre = self.genre
            return coredata.save(newObject)

        }

    }

}
