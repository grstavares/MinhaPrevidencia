//
//  NewsMessageTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class NewsMessageTest: XCTestCase {

    let secondsInDay: Double = 1 * 24 * 60 * 60
    let mockUuid = "MockUUID"
    let mockTitle = "MockTitle"
    let mockContent = "MockContent"
    let mockUrl = "http://www.google.com"

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
        let object = NewsMessage(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.title, mockTitle, "Title not Equal")
        XCTAssertEqual(object?.contents, self.mockContent, "Content not Equal")
        XCTAssertEqual(object?.url?.absoluteString, mockUrl, "URL not Equal")

        XCTAssert(mockCreation.compare(notnil.dateCreation) == .orderedSame, "DateCreation not Equal")
        if let updateNotNil = object?.lastUpdate {
            XCTAssert(mockReception.compare(updateNotNil) == .orderedSame, "LastUpdate Date not Equal")
        } else {XCTFail("LastUpdate Date not Parsed")}

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = NewsMessage(from: rawObject)
        }
    }

    private func getRawObject() -> RawNewsMessage {

        return RawNewsMessage(
            uuid: self.mockUuid,
            title: self.mockTitle,
            contents: self.mockContent,
            dateCreation: mockCreation.timeIntervalSince1970,
            lastUpdate: mockReception.timeIntervalSince1970,
            url: mockUrl
        )

    }

}
