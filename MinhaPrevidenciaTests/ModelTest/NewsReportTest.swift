//
//  NewsReportTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class NewsReportTest: XCTestCase {

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
        let object = NewsReport(from: rawObject)
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

    func testObjectCreationFromData() {

        let data = self.encodeRaw()
        let object = NewsReport(from: data)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.title, mockTitle, "Title not Equal")
        XCTAssertEqual(object?.contents, self.mockContent, "Content not Equal")
        XCTAssertEqual(object?.url?.absoluteString, mockUrl, "URL not Equal")

        XCTAssert(mockCreation.compare(notnil.dateCreation) == .orderedSame, "DateCreation not Equal")
        if let updateNotNil = object?.lastUpdate {
            XCTAssert(mockReception.compare(updateNotNil) == .orderedSame, "LastUpdate Date not Equal")
        } else {XCTFail("LastUpdate Date not Parsed")}

    }

    func testObjectCreationFromDataWithFailure() {

        let data = RetirementTest().encodeRaw()
        let object = NewsReport(from: data)
        XCTAssertNil(object, "Wrong Data parsed in Object")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = NewsReport(from: rawObject)
        }
    }

    private func getRawObject() -> RawNewsReport {

        return RawNewsReport(
            uuid: self.mockUuid,
            title: self.mockTitle,
            contents: self.mockContent,
            dateCreation: mockCreation.timeIntervalSince1970,
            lastUpdate: mockReception.timeIntervalSince1970,
            url: mockUrl
        )

    }

    func encodeRaw() -> Data {

        let object = self.getRawObject()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {return data
        } else {fatalError("Test Object can not be encoded")}

    }

}
