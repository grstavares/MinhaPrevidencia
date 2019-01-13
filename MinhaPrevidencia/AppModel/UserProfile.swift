//
//  UserProfile.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct UserProfile {

    let uuid: String
    let firstName: String
    let lastName: String
    let username: String?                //Save E-mail Here
    let phoneNumber: String?             //Save only numbers, with CountryCode and DDD
    let birthDate: Date?
    let genre: String?
    let wasDeleted: Bool

}

extension UserProfile: Hashable, Equatable, JsonConvertible {

    init(uuid: String, firstName: String, lastName: String, username: String?, phoneNumber: String?, birthDate: Date?, genre: String?) {

        self.uuid = uuid
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.phoneNumber = phoneNumber
        self.birthDate = birthDate
        self.genre = genre
        self.wasDeleted = false

    }

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawUserProfile.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawUserProfile) {

        var birth: Date?

        if let birthValue = raw.birthDate {birth = Date(timeIntervalSince1970: birthValue)}

        self.uuid = raw.uuid
        self.firstName = raw.firstName
        self.lastName = raw.lastName
        self.username = raw.username
        self.phoneNumber = raw.phoneNumber
        self.birthDate = birth
        self.genre = raw.genre
        self.wasDeleted = raw.wasDeleted

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawUserProfile {

        let birth = self.birthDate?.timeIntervalSince1970

        let raw = RawUserProfile(
            uuid: self.uuid, firstName: self.firstName, lastName: self.lastName,
            username: self.username, phoneNumber: self.phoneNumber,
            birthDate: birth, genre: self.genre, wasDeleted: self.wasDeleted
        )

        return raw

    }

}

struct RawUserProfile: Codable, Hashable, Equatable {

    let uuid: String
    let firstName: String
    let lastName: String
    let username: String?
    let phoneNumber: String?
    let birthDate: Double?
    let genre: String?
    let wasDeleted: Bool

}

//struct UserProfileBuilder {
//
//    let uuid: String
//    let firstName: String
//    let lastName: String
//    let username: String?
//    let phoneNumber: String?
//    let birthDate: Date?
//    let genre: String?
//    let wasDeleted: Bool
//
//    func build() -> UserProfile {
//
//        return UserProfile(
//            uuid: self.uuid,
//            firstName: self.firstName,
//            lastName: self.lastName,
//            username: self.username,
//            phoneNumber: self.phoneNumber,
//            birthDate: self.birthDate,
//            genre: self.genre,
//            wasDeleted: self.wasDeleted
//        )
//
//    }
//}
