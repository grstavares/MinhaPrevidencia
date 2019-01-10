//
//  Complaint.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct Complaint {

    enum Status: String {
        case open, inEvaluation, inProgress, closed
    }

    let uuid: String
    let title: String
    let content: String
    let dateCreation: Date
    let dateReception: Date?
    let status: Status

}

extension Complaint: Hashable, Equatable, JsonConvertible {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RawComplaint.self, from: data) else { return nil }
        self.init(from: decoded)

    }

    init?(from raw: RawComplaint) {

        var dateReception: Date?

        guard let statusValue = Status(rawValue: raw.status) else {return nil}
        if let receptionValue = raw.dateReception {dateReception = Date(timeIntervalSince1970: receptionValue)}

        self.uuid = raw.uuid
        self.title = raw.title
        self.content = raw.content
        self.dateCreation = Date(timeIntervalSince1970: raw.dateCreation)
        self.dateReception = dateReception
        self.status = statusValue

    }

    func asJsonData() -> Data? {

        let raw = self.raw()
        let encoder = JSONEncoder()
        return try? encoder.encode(raw)

    }

    func raw() -> RawComplaint {

        let dateCreation = self.dateCreation.timeIntervalSince1970
        let dateReception = self.dateReception?.timeIntervalSince1970

        let raw = RawComplaint(
            uuid: self.uuid, title: self.title, content: self.content,
            dateCreation: dateCreation, dateReception: dateReception,
            status: self.status.rawValue
        )

        return raw

    }

}

struct RawComplaint: Codable, Hashable, Equatable {

    let uuid: String
    let title: String
    let content: String
    let dateCreation: Double
    let dateReception: Double?
    let status: String

}

struct ComplaintBuilder {

    let uuid: String
    let title: String
    let content: String
    let dateCreation: Date
    let dateReception: Date?
    let status: Complaint.Status
    func build() -> Complaint { return Complaint(uuid: self.uuid, title: self.title, content: self.content, dateCreation: self.dateCreation, dateReception: self.dateReception, status: self.status) }

}
