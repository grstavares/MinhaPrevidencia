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

}

extension Institution: Equatable, Hashable, JsonConvertible {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawInstitution.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawInstitution) {

        self.uuid = raw.uuid
        self.name = raw.name

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawInstitution {

        let raw = RawInstitution(uuid: self.uuid, name: self.name)
        return raw

    }

}

struct RawInstitution: Codable, Equatable, Hashable {

    let uuid: String
    let name: String

}

struct InstitutionBuilder {

    let uuid: String
    let name: String
    func build() -> Institution { return Institution(uuid: uuid, name: name) }

}
