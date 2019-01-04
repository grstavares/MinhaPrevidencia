//
//  Retirement.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct Retirement {

    let uuid: String
    let startDate: Date
    let endDate: Date
    let contributions: [Contribution]
    let withdrawals: [Withdrawal]

}

extension Retirement: Hashable, Equatable, JsonConvertible {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawRetirement.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawRetirement) {

        self.uuid = raw.uuid
        self.startDate = Date(timeIntervalSince1970: raw.startDate)
        self.endDate = Date(timeIntervalSince1970: raw.endDate)
        self.contributions = raw.contributions.compactMap({ (rawitem) -> Contribution? in Contribution(from: rawitem) })
        self.withdrawals = raw.withdrawals.compactMap({ (rawItem) -> Withdrawal? in Withdrawal(from: rawItem)})

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawRetirement {

        let startDate = self.startDate.timeIntervalSince1970
        let endDate = self.endDate.timeIntervalSince1970

        let contributions = self.contributions.map { $0.raw() }
        let withdrawals = self.withdrawals.map { $0.raw() }

        let raw = RawRetirement(uuid: self.uuid, startDate: startDate, endDate: endDate, contributions: contributions, withdrawals: withdrawals)
        return raw

    }

}

struct RawRetirement: Codable, Hashable, Equatable {

    let uuid: String
    let startDate: Double
    let endDate: Double
    let contributions: [RawContribution]
    let withdrawals: [RawWithdrawal]

}
