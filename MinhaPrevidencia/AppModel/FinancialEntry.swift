//
//  FinancialEntry.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 13/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct FinancialEntry {

    let uuid: String
    let date: Date
    let period: ClosedRange<Date>
    let subject: String
    let description: String?
    let value: Double
    let details: URL?
    let isIncome: Bool
    let entryCategory: String?
    let wasDeleted: Bool

}

extension FinancialEntry: Hashable, Equatable, JsonConvertible {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawFinancialEntry.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawFinancialEntry) {

        self.uuid = raw.uuid
        self.date = raw.date
        self.period = raw.startDate...raw.endDate
        self.subject = raw.subject
        self.description = raw.description
        self.value = raw.value
        self.details = raw.details
        self.isIncome = raw.isIncome
        self.entryCategory = raw.entryCategory
        self.wasDeleted = raw.wasDeleted

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawFinancialEntry {

        let raw = RawFinancialEntry(
            uuid: self.uuid,
            date: self.date,
            startDate: self.period.lowerBound,
            endDate: self.period.upperBound,
            subject: self.subject,
            description: self.description,
            value: self.value,
            details: self.details,
            isIncome: self.isIncome,
            entryCategory: self.entryCategory,
            wasDeleted: self.wasDeleted
        )

        return raw

    }

}

struct RawFinancialEntry: Codable, Hashable, Equatable {

    let uuid: String
    let date: Date
    let startDate: Date
    let endDate: Date
    let subject: String
    let description: String?
    let value: Double
    let details: URL?
    let isIncome: Bool
    let entryCategory: String?
    let wasDeleted: Bool

}

//struct FinancialEntryBuilder {
//
//    let uuid: String
//    let date: Date
//    let startDate: Date
//    let endDate: Date
//    let subject: String
//    let description: String?
//    let value: Double
//    let details: URL?
//    let wasDeleted: Bool
//
//    func build() -> FinancialEntry {
//
//        return FinancialEntry(
//            uuid: self.uuid,
//            date: self.date,
//            period: self.startDate...self.endDate,
//            subject: self.subject,
//            description: self.description,
//            value: self.value,
//            details: self.details,
//            wasDeleted: self.wasDeleted
//        )
//
//    }
//
//}
