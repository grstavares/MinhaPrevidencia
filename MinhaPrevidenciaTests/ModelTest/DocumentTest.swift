//
//  DocumentTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class DocumentTest: XCTestCase {

    let secondsInDay: Double = 1 * 24 * 60 * 60
    let uuid = "MockUUID"
    let title = "MockTitle"
    let content = "MockContent"
    let mockUrl = "https://www.google.com"
    let status = Complaint.Status.inProgress.rawValue

    let mockCreation = DateComponents(
        calendar: Calendar.current, timeZone: TimeZone.current,
        era: nil,
        year: 1970, month: 11, day: 10,
        hour: 0, minute: 0, second: 0, nanosecond: 0,
        weekday: nil, weekdayOrdinal: nil, quarter: nil,
        weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
        ).date!

    let mockReception = DateComponents(
        calendar: Calendar.current, timeZone: TimeZone.current,
        era: nil,
        year: 2030, month: 11, day: 10,
        hour: 0, minute: 0, second: 0, nanosecond: 0,
        weekday: nil, weekdayOrdinal: nil, quarter: nil,
        weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
        ).date!

    override func setUp() { }

    override func tearDown() { }

    func testObjectCreationFromRaw() {

        let rawObject = self.getRawObject()
        let object = Document(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, uuid, "UUID not Equal")
        XCTAssertEqual(object?.title, title, "Title not Equal")
        XCTAssertEqual(object?.summary, content, "Summary not Equal")
        XCTAssertEqual(object?.url.absoluteString, mockUrl, "Url not Equal")

        XCTAssert(mockCreation.compare(notnil.dateCreation) == .orderedSame, "DateCreation not Equal")
        if let receptionNotNil = object?.lastUpdate {
            XCTAssert(mockReception.compare(receptionNotNil) == .orderedSame, "LastUpdate Date not Equal")
        } else {XCTFail("LastUpdate Date not Parsed")}

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = Document(from: rawObject)
        }
    }

    private func getRawObject() -> RawDocument {

        return RawDocument(
            uuid: uuid,
            title: title,
            summary: content,
            dateCreation: mockCreation.timeIntervalSince1970,
            lastUpdate: mockReception.timeIntervalSince1970,
            url: mockUrl
        )

    }

}
