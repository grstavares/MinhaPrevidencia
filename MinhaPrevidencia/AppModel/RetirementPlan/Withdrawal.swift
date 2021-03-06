//
//  Withdrawal.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct Withdrawal {

    let uuid: String
    let date: Date
    let value: Double
    let reference: String
    let wasDeleted: Bool

}

extension Withdrawal: Hashable, Equatable, JsonConvertible {

    init(uuid: String, date: Date, value: Double, reference: String) {

        self.uuid = uuid
        self.date = date
        self.value = value
        self.reference = reference
        self.wasDeleted = false

    }

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawWithdrawal.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawWithdrawal) {

        let date = Date(timeIntervalSince1970: raw.date)

        self.uuid = raw.uuid
        self.date = date
        self.value = raw.value
        self.reference = raw.reference
        self.wasDeleted = raw.wasDeleted

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawWithdrawal {

        let date = self.date.timeIntervalSince1970
        let raw = RawWithdrawal(uuid: self.uuid, date: date, value: self.value, reference: self.reference, wasDeleted: self.wasDeleted)
        return raw

    }

}

struct RawWithdrawal: Codable, Hashable, Equatable {

    let uuid: String
    let date: Double
    let value: Double
    let reference: String
    let wasDeleted: Bool

}

//struct WithdrawalBuilder {
//
//    let uuid: String
//    let date: Date
//    let value: Double
//    let reference: String
//    let wasDeleted: Bool
//
//    func build() -> Withdrawal { return Withdrawal(uuid: self.uuid, date: self.date, value: self.value, reference: self.reference, wasDeleted: self.wasDeleted) }
//
//}
