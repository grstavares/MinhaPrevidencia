//
//  Address.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreLocation

struct Address {

    let uuid: String
    let country: String             // The two-letter ISO 3166-1 alpha-2 country code.
    let region: String              // The two-letter abbreviation for State or Province
    let city: String                // Fullname of the City
    let postalCode: String          // Official PostalCode
    let streetAddress: String?
    let streetNumber: String?
    let buildName: String?
    let unitNumber: String?
    let location: CLLocation?

    let isMain: Bool
    let wasDeleted: Bool
}

extension Address: Equatable, Hashable, JsonConvertible {

    init(uuid: String, country: String, region: String, city: String, postalCode: String, streetAddress: String?, streetNumber: String?, buildName: String?, unitNumber: String?, location: CLLocation?, isMain: Bool) {

        self.uuid = uuid
        self.country = country
        self.region = region
        self.city = city
        self.postalCode = postalCode
        self.streetAddress = streetAddress
        self.streetNumber = streetNumber
        self.buildName = buildName
        self.unitNumber = unitNumber
        self.location = location
        self.isMain = isMain
        self.wasDeleted = false

    }

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawAddress.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawAddress) {

        self.uuid = raw.uuid
        self.country = raw.country
        self.region = raw.region
        self.city = raw.city
        self.postalCode = raw.postalCode
        self.streetAddress = raw.streetAddress
        self.streetNumber = raw.streetNumber
        self.buildName = raw.buildName
        self.unitNumber = raw.unityNumber
        self.isMain = raw.isMain
        self.wasDeleted = raw.wasDeleted

        if let latitude = raw.latitude, let longitude = raw.longitude {
            self.location = CLLocation(latitude: latitude, longitude: longitude)
        } else {self.location = nil}

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawAddress {

        let raw = RawAddress(
            uuid: self.uuid,
            country: self.country, region: self.region, city: self.city,
            postalCode: self.postalCode,
            streetAddress: self.streetAddress, streetNumber: self.streetNumber,
            buildName: self.buildName, unityNumber: self.unitNumber,
            latitude: self.location?.coordinate.latitude, longitude: self.location?.coordinate.longitude,
            isMain: self.isMain, wasDeleted: self.wasDeleted
        )

        return raw

    }

}

struct RawAddress: Codable, Equatable, Hashable {

    let uuid: String
    let country: String             // The two-letter ISO 3166-1 alpha-2 country code.
    let region: String              // The two-letter abbreviation for State or Province
    let city: String                // Fullname of the City
    let postalCode: String          // Official PostalCode
    let streetAddress: String?
    let streetNumber: String?
    let buildName: String?
    let unityNumber: String?
    let latitude: Double?
    let longitude: Double?
    let isMain: Bool
    let wasDeleted: Bool

}

//struct AddressBuilder {
//
//    let uuid: String
//    let country: String
//    let region: String
//    let city: String
//    let postalCode: String
//    let streetAddress: String?
//    let streetNumber: String?
//    let buildName: String?
//    let unitNumber: String?
//    let latitude: Double?
//    let longitude: Double?
//    let isMain: Bool
//    let wasDeleted: Bool
//
//    func build() -> Address {
//
//        var location: CLLocation?
//        if let lat = self.latitude, let lon = self.longitude {
//            location = CLLocation(latitude: lat, longitude: lon)
//        }
//
//        return Address(
//            uuid: self.uuid,
//            country: self.country,
//            region: self.region,
//            city: self.city,
//            postalCode: self.postalCode,
//            streetAddress: self.streetAddress,
//            streetNumber: self.streetNumber,
//            buildName: self.buildName,
//            unitNumber: self.unitNumber,
//            location: location,
//            isMain: self.isMain,
//            wasDeleted: self.wasDeleted
//        )
//
//    }
//
//}
