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

    let country: String             // The two-letter ISO 3166-1 alpha-2 country code.
    let region: String              // The two-letter abbreviation for State or Province
    let city: String                // Fullname of the City
    let postalCode: String          // Official PostalCode
    let streetAddress: String?
    let streetNumber: String?
    let buildName: String?
    let unityNumber: String?
    let location: CLLocation?

    let isMain: Bool

}

extension Address: Equatable, Hashable, JsonConvertible {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawAddress.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawAddress) {

        self.country = raw.country
        self.region = raw.region
        self.city = raw.city
        self.postalCode = raw.postalCode
        self.streetAddress = raw.streetAddress
        self.streetNumber = raw.streetNumber
        self.buildName = raw.buildName
        self.unityNumber = raw.unityNumber
        self.isMain = raw.isMain

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
            country: self.country, region: self.region, city: self.city,
            postalCode: self.postalCode,
            streetAddress: self.streetAddress, streetNumber: self.streetNumber,
            buildName: self.buildName, unityNumber: self.unityNumber,
            latitude: self.location?.coordinate.latitude, longitude: self.location?.coordinate.longitude,
            isMain: self.isMain
        )

        return raw

    }

}

struct RawAddress: Codable, Equatable, Hashable {

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

}
