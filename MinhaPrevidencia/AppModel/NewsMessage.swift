//
//  NewsMessage.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct NewsMessage {

    let uuid: String
    let title: String
    let contents: String
    let dateCreation: Date
    let lastUpdate: Date?
    let url: URL?

}

extension NewsMessage: Hashable, Equatable, JsonConvertible {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawNewsMessage.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawNewsMessage) {

        var dateUpdate: Date?
        var urlValue: URL?

        if let notEmpty = raw.url {urlValue = URL(string: notEmpty)}
        if let updatedValue = raw.lastUpdate {dateUpdate = Date(timeIntervalSince1970: updatedValue)}

        self.uuid = raw.uuid
        self.title = raw.title
        self.contents = raw.contents
        self.dateCreation = Date(timeIntervalSince1970: raw.dateCreation)
        self.lastUpdate = dateUpdate
        self.url = urlValue

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawNewsMessage {

        let dateCreation = self.dateCreation.timeIntervalSince1970
        let dateUpdate = self.lastUpdate?.timeIntervalSince1970

        let raw = RawNewsMessage(
            uuid: self.uuid, title: self.title, contents: self.contents,
            dateCreation: dateCreation, lastUpdate: dateUpdate,
            url: self.url?.absoluteString
        )

        return raw

    }

}

struct RawNewsMessage: Codable, Hashable, Equatable {

    let uuid: String
    let title: String
    let contents: String
    let dateCreation: Double
    let lastUpdate: Double?
    let url: String?

}
