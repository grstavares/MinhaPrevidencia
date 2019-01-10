//
//  Contributions.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct Contribution {

    let uuid: String
    let source: String
    let reference: Date
    let value: Double

}

extension Contribution: Hashable, Equatable, JsonConvertible {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawContribution.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawContribution) {

        let date = Date(timeIntervalSince1970: raw.reference)

        self.uuid = raw.uuid
        self.source = raw.source
        self.reference = date
        self.value = raw.value

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawContribution {

        let date = self.reference.timeIntervalSince1970
        let raw = RawContribution(uuid: self.uuid, source: self.source, reference: date, value: self.value)
        return raw

    }

}

struct RawContribution: Codable, Hashable, Equatable {

    let uuid: String
    let source: String
    let reference: Double
    let value: Double

}

struct ContributionBuilder {

    let uuid: String
    let source: String
    let reference: Date
    let value: Double
    func build() -> Contribution { return Contribution(uuid: self.uuid, source: self.source, reference: self.reference, value: self.value) }

}
