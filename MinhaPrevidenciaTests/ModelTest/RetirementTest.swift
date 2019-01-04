//
//  RetirementTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class RetirementTest: XCTestCase {

    let secondsInDay: Double = 1 * 24 * 60 * 60
    let mockUuid = "MockUUID"
    let mockContributions: [RawContribution] = [ContributionTest().getRawObject()]
    let mockWithDrawals: [RawWithdrawal] = [WithdrawalTest().getRawObject()]

    let mockStart = DateComponents(
        calendar: Calendar.current, timeZone: TimeZone.current,
        era: nil,
        year: 1970, month: 11, day: 10,
        hour: 0, minute: 0, second: 0, nanosecond: 0,
        weekday: nil, weekdayOrdinal: nil, quarter: nil,
        weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
    ).date!

    let mockEnd = DateComponents(
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
        let object = Retirement(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        let parsedContributions = self.mockContributions.compactMap { (raw) in Contribution(from: raw) }
        let parsedWithDrawals = self.mockWithDrawals.compactMap { (raw) in Withdrawal(from: raw) }

        XCTAssertEqual(object?.uuid, self.mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.contributions, parsedContributions, "Title not Equal")
        XCTAssertEqual(object?.withdrawals, parsedWithDrawals, "Content not Equal")
        XCTAssert(self.mockStart.compare(notnil.startDate) == .orderedSame, "DateCreation not Equal")
        XCTAssert(self.mockEnd.compare(notnil.endDate) == .orderedSame, "DateCreation not Equal")

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = Retirement(from: rawObject)
        }
    }

    private func getRawObject() -> RawRetirement {

        return RawRetirement(
            uuid: mockUuid,
            startDate: mockStart.timeIntervalSince1970,
            endDate: mockEnd.timeIntervalSince1970,
            contributions: mockContributions,
            withdrawals: mockWithDrawals
        )

    }

}
