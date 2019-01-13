//
//  NewsReport.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct NewsReport {

    let uuid: String
    let title: String
    let contents: String
    let dateCreation: Date
    let lastUpdate: Date?
    let url: URL?
    let wasDeleted: Bool

}

extension NewsReport: Hashable, Equatable, JsonConvertible {

    init(uuid: String, title: String, contents: String, dateCreation: Date, lastUpdate: Date?, url: URL?) {

        self.uuid = uuid
        self.title = title
        self.contents = contents
        self.dateCreation = dateCreation
        self.lastUpdate = lastUpdate
        self.url = url
        self.wasDeleted = false

    }

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawNewsReport.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawNewsReport) {

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
        self.wasDeleted = raw.wasDeleted

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawNewsReport {

        let dateCreation = self.dateCreation.timeIntervalSince1970
        let dateUpdate = self.lastUpdate?.timeIntervalSince1970

        let raw = RawNewsReport(
            uuid: self.uuid, title: self.title, contents: self.contents,
            dateCreation: dateCreation, lastUpdate: dateUpdate,
            url: self.url?.absoluteString, wasDeleted: self.wasDeleted
        )

        return raw

    }

}

struct RawNewsReport: Codable, Hashable, Equatable {

    let uuid: String
    let title: String
    let contents: String
    let dateCreation: Double
    let lastUpdate: Double?
    let url: String?
    let wasDeleted: Bool

}

//struct NewsReportBuilder {
//
//    let uuid: String
//    let title: String
//    let contents: String
//    let dateCreation: Date
//    let lastUpdate: Date?
//    let url: URL?
//    let wasDeleted: Bool
//    func build() -> NewsReport { return NewsReport(uuid: self.uuid, title: self.title, contents: self.contents, dateCreation: self.dateCreation, lastUpdate: self.lastUpdate, url: self.url, wasDeleted: self.wasDeleted) }
//
//}
