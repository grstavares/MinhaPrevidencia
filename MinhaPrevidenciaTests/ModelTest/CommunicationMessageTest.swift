//
//  CommunicationMessageTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class CommunicationMessageTest: XCTestCase {

    let secondsInDay: Double = 1 * 24 * 60 * 60
    let mockUuid = "MockUUID"
    let mockTitle = "MockTitle"
    let mockSummary = "MockSummary"
    let mockContent = "MockContent"
    let mockOrigin = "MockOrigin"
    let mockDestiny = ["MockDestinyA", "MockDestinyB"]

    let mockCreation = DateComponents(
        calendar: Calendar.current, timeZone: TimeZone.current,
        era: nil,
        year: 1970, month: 11, day: 10,
        hour: 0, minute: 0, second: 0, nanosecond: 0,
        weekday: nil, weekdayOrdinal: nil, quarter: nil,
        weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
        ).date!

    override func setUp() { }

    override func tearDown() { }

    func testObjectCreationFromRaw() {

        let rawObject = self.getRawObject()
        let object = ComunicationMessage(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.title, mockTitle, "Title not Equal")
        XCTAssertEqual(object?.summary, mockSummary, "Summary not Equal")
        XCTAssertEqual(object?.content, mockContent, "Content not Equal")
        XCTAssertEqual(object?.userOrigin, mockOrigin, "Origin not Equal")
        XCTAssertEqual(object?.recipients, mockDestiny, "Recipients not Equal")
        XCTAssert(mockCreation.compare(notnil.dateCreation) == .orderedSame, "DateCreation not Equal")

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = ComunicationMessage(from: rawObject)
        }
    }

    private func getRawObject() -> RawComunicationMessage {

        return RawComunicationMessage(
            uuid: self.mockUuid,
            title: self.mockTitle,
            summary: self.mockSummary,
            content: self.mockContent,
            dateCreation: mockCreation.timeIntervalSince1970,
            userOrigin: self.mockOrigin,
            recipients: self.mockDestiny
        )

    }

}
