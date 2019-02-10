//
//  Institution.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct Institution {

    let uuid: String
    let name: String
    let wasDeleted: Bool

}

extension Institution: Equatable, Hashable, JsonConvertible {

    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
        self.wasDeleted = false
    }

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawInstitution.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawInstitution) {

        self.uuid = raw.institutionId
        self.name = raw.name
        self.wasDeleted = raw.wasDeleted

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawInstitution {

        let raw = RawInstitution(institutionId: self.uuid, name: self.name, wasDeleted: self.wasDeleted)
        return raw

    }

}

struct RawInstitution: Codable, Equatable, Hashable {

    let institutionId: String
    let name: String
    let wasDeleted: Bool

}

extension RawInstitution {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.institutionId = try container.decode(String.self, forKey: .institutionId)
        self.name = try container.decode(String.self, forKey: .name)
        self.wasDeleted = try container.decodeIfPresent(Bool.self, forKey: .wasDeleted) ?? false
    }

}
