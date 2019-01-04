//
//  ContributionTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class ContributionTest: XCTestCase {

    let secondsInDay: Double = 1 * 24 * 60 * 60
    let mockUuid = "MockUUID"
    let mockSource = "MockSource"
    let mockValue: Double = 77634.99

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
        let object = Contribution(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.source, mockSource, "Source not Equal")
        XCTAssertEqual(object?.value, mockValue, "Value not Equal")
        XCTAssert(mockCreation.compare(notnil.reference) == .orderedSame, "Date not Equal")

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = Contribution(from: rawObject)
        }
    }

    func getRawObject() -> RawContribution {

        return RawContribution(uuid: self.mockUuid, source: self.mockSource, reference: mockCreation.timeIntervalSince1970, value: mockValue)

    }

}
