//
//  Message.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct CommunicationMessage {

    let uuid: String
    let title: String
    let summary: String?
    let content: String
    let dateCreation: Date
    let userOrigin: String
    let recipients: [String]

}

extension CommunicationMessage: Hashable, Equatable, JsonConvertible {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawComunicationMessage.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawComunicationMessage) {

        self.uuid = raw.uuid
        self.title = raw.title
        self.summary = raw.summary
        self.content = raw.content
        self.dateCreation = Date(timeIntervalSince1970: raw.dateCreation)
        self.userOrigin = raw.userOrigin
        self.recipients = raw.recipients

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawComunicationMessage {

        let dateCreation = self.dateCreation.timeIntervalSince1970

        let raw = RawComunicationMessage(
            uuid: self.uuid, title: self.title, summary: self.summary, content: self.content,
            dateCreation: dateCreation, userOrigin: self.userOrigin, recipients: self.recipients
        )

        return raw

    }

}

struct RawComunicationMessage: Codable, Hashable, Equatable {

    let uuid: String
    let title: String
    let summary: String?
    let content: String
    let dateCreation: Double
    let userOrigin: String
    let recipients: [String]

}

struct CommunicationMessageBuilder {

    let uuid: String
    let title: String
    let summary: String?
    let content: String
    let dateCreation: Date
    let userOrigin: String
    let recipients: [String]
    func build() -> CommunicationMessage {

        return CommunicationMessage(
            uuid: self.uuid,
            title: self.title,
            summary: self.summary,
            content: self.content,
            dateCreation: self.dateCreation,
            userOrigin: self.userOrigin,
            recipients: self.recipients
        )

    }

}
