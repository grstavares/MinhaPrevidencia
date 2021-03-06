//
//  Address+CoreData.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import SwiftSugarKit

extension Address: AbstractCoreDataStoreItem {

    typealias ObjectModel = Address
//    typealias ObjectBuilder = AddressBuilder
    typealias CoreDataModel = AddressCoreData

    static var entityName: String { return "AddressCoreData" }

    static func parseObject(coredataObject object: CoreDataModel) -> ObjectModel? {

        guard let uuid = object.uuid, let country = object.country, let region = object.region, let city = object.city, let postal = object.postalCode else { return nil }
        let strAddress = object.streetAddress
        let strNumber = object.streetNumber
        let build = object.buildName
        let unit = object.unitNumber
        let latitude: Double? = object.latitude
        let longitude: Double? = object.longitude
        let isMain = object.isMain
        let wasDeleted = object.wasDeleted

        var location: CLLocation?
        if let lat = latitude, let lon = longitude, lat != 0, lon != 0 {
            location = CLLocation(latitude: lat, longitude: lon)
        }

        let document = ObjectModel(
            uuid: uuid,
            country: country,
            region: region,
            city: city,
            postalCode: postal,
            streetAddress: strAddress,
            streetNumber: strNumber,
            buildName: build,
            unitNumber: unit,
            location: location,
            isMain: isMain,
            wasDeleted: wasDeleted)

        return document

    }

    func saveInDataStore(manager: DataStoreManager) throws -> Bool {

        guard let coredata = manager as? CoreDataManager else {
            throw DataStoreError.invalidManager(expected: "CoreData", actual: manager.description)
        }

        if let first: CoreDataModel = try ObjectModel.loadManagedObject(uuid: uuid, entityName: ObjectModel.entityName, manager: coredata) {
            first.country = self.country
            first.region = self.region
            first.city = self.city
            first.postalCode = self.postalCode
            first.streetAddress = self.streetAddress
            first.streetNumber = self.streetNumber
            first.buildName = self.buildName
            first.unitNumber = self.unitNumber
            first.latitude = self.location?.coordinate.latitude ?? 0
            first.longitude = self.location?.coordinate.longitude ?? 0
            first.wasDeleted = self.wasDeleted
            coredata.sync()
            return true
        } else {

            guard let entityDescription = NSEntityDescription.entity(forEntityName: ObjectModel.entityName, in: coredata.managedObjectContext) else {
                throw DataStoreError.invalidEntity(entityName: ObjectModel.entityName)
            }

            let newObject = CoreDataModel.init(entity: entityDescription, insertInto: coredata.managedObjectContext)
            newObject.uuid = self.uuid
            newObject.country = self.country
            newObject.region = self.region
            newObject.city = self.city
            newObject.postalCode = self.postalCode
            newObject.streetAddress = self.streetAddress
            newObject.streetNumber = self.streetNumber
            newObject.buildName = self.buildName
            newObject.unitNumber = self.unitNumber
            newObject.latitude = self.location?.coordinate.latitude ?? 0
            newObject.longitude = self.location?.coordinate.longitude ?? 0
            newObject.wasDeleted = self.wasDeleted
            return coredata.save(newObject)

        }

    }

}
