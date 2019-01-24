//
//  Document.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct Document {

    let uuid: String
    let title: String
    let summary: String
    let dateCreation: Date
    let lastUpdate: Date?
    let url: URL
    let wasDeleted: Bool

}

extension Document: Hashable, Equatable, JsonConvertible {

    init(uuid: String, title: String, summary: String, dateCreation: Date, lastUpdate: Date?, url: URL) {

        self.uuid = uuid
        self.title = title
        self.summary = summary
        self.dateCreation = dateCreation
        self.lastUpdate = lastUpdate
        self.url = url
        self.wasDeleted = false
    }

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawDocument.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawDocument) {

        var dateUpdate: Date?

        guard let urlValue = URL(string: raw.url) else {return nil}
        if let updatedValue = raw.lastUpdate {dateUpdate = Date(timeIntervalSince1970: updatedValue)}

        self.uuid = raw.uuid
        self.title = raw.title
        self.summary = raw.summary
        self.dateCreation = Date(timeIntervalSince1970: raw.dateCreation)
        self.lastUpdate = dateUpdate
        self.url = urlValue
        self.wasDeleted = raw.wasDeleted

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawDocument {

        let dateCreation = self.dateCreation.timeIntervalSince1970
        let dateUpdate = self.lastUpdate?.timeIntervalSince1970

        let raw = RawDocument(
            uuid: self.uuid, title: self.title, summary: self.summary,
            dateCreation: dateCreation, lastUpdate: dateUpdate,
            url: self.url.absoluteString, wasDeleted: self.wasDeleted
        )

        return raw

    }

}

struct RawDocument: Codable, Hashable, Equatable {

    let uuid: String
    let title: String
    let summary: String
    let dateCreation: Double
    let lastUpdate: Double?
    let url: String
    let wasDeleted: Bool

}
