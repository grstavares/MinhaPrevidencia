//
//  FinancialEntryTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 13/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class FinancialEntryTest: XCTestCase {

//    let secondsInDay: Double = 1 * 24 * 60 * 60
    let mockDate = Date()
    let mockUuid = "MockUUID"
    let mockValue: Double = 765.98
    let mockSubject = "MockReferece"
    let mockDescription = "MockDescription"
    let mockDetails = URL(string: "https://www.google.com")

    var mockStart: Date!
    var mockEnd: Date!

    override func setUp() {

        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let range = Calendar.current.range(of: .day, in: .month, for: Date())!

        self.mockStart = DateComponents(
            calendar: Calendar.current, timeZone: TimeZone.current,
            era: nil,
            year: dateComponents.year, month: dateComponents.month, day: 1,
            hour: 0, minute: 0, second: 0, nanosecond: 0,
            weekday: nil, weekdayOrdinal: nil, quarter: nil,
            weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
            ).date!

        self.mockEnd = DateComponents(
            calendar: Calendar.current, timeZone: TimeZone.current,
            era: nil,
            year: dateComponents.year, month: dateComponents.month, day: range.count,
            hour: 0, minute: 0, second: 0, nanosecond: 0,
            weekday: nil, weekdayOrdinal: nil, quarter: nil,
            weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
            ).date!

    }

    override func tearDown() { }

    func testObjectCreationFromRaw() {

        let rawObject = self.getRawObject()
        let object = FinancialEntry(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, mockUuid, "UUID not Equal")
        XCTAssertEqual(notnil.value, mockValue, accuracy: 0.1)
        XCTAssert(mockDate.compare(notnil.date) == .orderedSame, "Date not Equal")

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectCreationFromData() {

        let data = self.encodeRaw()
        let object = FinancialEntry(from: data)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.subject, mockSubject)
        XCTAssertEqual(object?.description, mockDescription)
        XCTAssertEqual(object?.details, mockDetails)
        XCTAssertEqual(notnil.value, mockValue, accuracy: 0.1)
        XCTAssert(mockDate.compare(notnil.date) == .orderedSame, "Date not Equal")
        XCTAssert(mockStart.compare(notnil.period.lowerBound) == .orderedSame, "Reference StartDate not Equal")
        XCTAssert(mockEnd.compare(notnil.period.upperBound) == .orderedSame, "Reference EndDate not Equal")

    }

    func testObjectCreationFromDataWithFailure() {

        let data = AddressTest().encodeRaw()
        let object = FinancialEntry(from: data)
        XCTAssertNil(object, "Wrong Data parsed in Object")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = FinancialEntry(from: rawObject)
        }
    }

    func getMockObject() -> FinancialEntry { return FinancialEntry(from: self.getRawObject())! }

    func getRawObject() -> RawFinancialEntry {

        self.setUp()
        return RawFinancialEntry(uuid: mockUuid, date: mockDate, startDate: mockStart, endDate: mockEnd, subject: mockSubject, description: mockDescription, value: mockValue, details: mockDetails, isIncome: false, entryCategory: nil, wasDeleted: false)

    }

    func encodeRaw() -> Data {

        let object = self.getRawObject()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {return data
        } else {fatalError("Test Object can not be encoded")}

    }

}
