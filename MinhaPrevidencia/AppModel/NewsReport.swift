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
    let imageUrl: URL?
    let wasDeleted: Bool

    //http://www.previdencia.gov.br/noticias/

}

extension NewsReport: Hashable, Equatable, JsonConvertible {

//    init(uuid: String, title: String, contents: String, dateCreation: Date, lastUpdate: Date?, url: URL?) {
//
//        self.uuid = uuid
//        self.title = title
//        self.contents = contents
//        self.dateCreation = dateCreation
//        self.lastUpdate = lastUpdate
//        self.url = url
//        self.wasDeleted = false
//
//    }

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawNewsReport.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawNewsReport) {

        var dateUpdate: Date?
        var urlValue: URL?
        var imgUrlValue: URL?

        if let notEmpty = raw.url {urlValue = URL(string: notEmpty)}
        if let notEmptyImg = raw.imageUrl {imgUrlValue = URL(string: notEmptyImg)}
        if let updatedValue = raw.lastUpdate {dateUpdate = Date(timeIntervalSince1970: updatedValue)}

        self.uuid = raw.itemId
        self.title = raw.title
        self.contents = raw.contents
        self.dateCreation = Date(timeIntervalSince1970: raw.dateCreation)
        self.lastUpdate = dateUpdate
        self.url = urlValue
        self.imageUrl = imgUrlValue
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
            itemId: self.uuid, title: self.title, contents: self.contents,
            dateCreation: dateCreation, lastUpdate: dateUpdate,
            url: self.url?.absoluteString, imageUrl: self.imageUrl?.absoluteString,
            wasDeleted: self.wasDeleted
        )

        return raw

    }

}

struct RawNewsReport: Codable, Hashable, Equatable {

    let itemId: String
    let title: String
    let contents: String
    let dateCreation: Double
    let lastUpdate: Double?
    let url: String?
    let imageUrl: String?
    let wasDeleted: Bool

}

extension RawNewsReport {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemId = try container.decode(String.self, forKey: .itemId)
        self.title = try container.decode(String.self, forKey: .title)
        self.contents = try container.decode(String.self, forKey: .contents)
        self.dateCreation = try container.decode(Double.self, forKey: .dateCreation)
        self.lastUpdate = try container.decodeIfPresent(Double.self, forKey: .lastUpdate)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.wasDeleted = try container.decodeIfPresent(Bool.self, forKey: .wasDeleted) ?? false
    }

}
