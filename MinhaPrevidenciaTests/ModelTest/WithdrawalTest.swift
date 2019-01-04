//
//  WithdrawalTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class WithdrawalTest: XCTestCase {

    let secondsInDay: Double = 1 * 24 * 60 * 60
    let mockUuid = "MockUUID"
    let mockValue: Double = 765.98
    let mockReference = "MockReferece"

    let mockDate = DateComponents(
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
        let object = Withdrawal(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, mockUuid, "UUID not Equal")
        XCTAssertEqual(notnil.value, mockValue, accuracy: 0.1)
        XCTAssertEqual(object?.reference, mockReference, "Reference not Equal")
        XCTAssert(mockDate.compare(notnil.date) == .orderedSame, "Date not Equal")

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = Withdrawal(from: rawObject)
        }
    }

    func getRawObject() -> RawWithdrawal {

        return RawWithdrawal(uuid: mockUuid, date: mockDate.timeIntervalSince1970, value: mockValue, reference: mockReference)

    }

}
