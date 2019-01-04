//
//  ComplaintTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class ComplaintTest: XCTestCase {

    let uuid = "MockUUID"
    let title = "MockTitle"
    let content = "MockContent"
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
        let object = Complaint(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, uuid, "UUID not Equal")
        XCTAssertEqual(object?.title, title, "Title not Equal")
        XCTAssertEqual(object?.content, content, "Content not Equal")
        XCTAssertEqual(object?.status.rawValue, status, "Status not Equal")

        XCTAssert(mockCreation.compare(notnil.dateCreation) == .orderedSame, "DateCreation not Equal")
        if let receptionNotNil = object?.dateReception {
            XCTAssert(mockReception.compare(receptionNotNil) == .orderedSame, "DateReception not Equal")
        } else {XCTFail("DateReception not Parsed")}

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = Complaint(from: rawObject)
        }
    }

    private func getRawObject() -> RawComplaint {

        return RawComplaint(
            uuid: uuid,
            title: title,
            content: content,
            dateCreation: mockCreation.timeIntervalSince1970,
            dateReception: mockReception.timeIntervalSince1970,
            status: status
        )

    }

}
