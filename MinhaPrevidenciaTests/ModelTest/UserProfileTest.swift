//
//  UserProfileTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class UserProfileTest: XCTestCase {

    let secondsInDay: Double = 1 * 24 * 60 * 60
    let mockUuid = "MockUUID"
    let mockFirst = "MockTitle"
    let mockLast = "MockSummary"
    let mockUsername = "MockContent"
    let mockGenre = "MockOrigin"

    let mockBirth = DateComponents(
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
        let object = UserProfile(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, self.mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.firstName, self.mockFirst, "FirstName not Equal")
        XCTAssertEqual(object?.lastName, self.mockLast, "Lastname not Equal")
        XCTAssertEqual(object?.username, self.mockUsername, "Username not Equal")
        XCTAssertEqual(object?.genre, self.mockGenre, "Genre not Equal")
        if let birthNotNil = object?.birthDate {
            XCTAssert(self.mockBirth.compare(birthNotNil) == .orderedSame, "BirthDate Date not Equal")
        } else {XCTFail("BirthDate Date not Parsed")}

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = UserProfile(from: rawObject)
        }
    }

    private func getRawObject() -> RawUserProfile {

        return RawUserProfile(uuid: mockUuid, firstName: mockFirst, lastName: mockLast, username: mockUsername, birthDate: mockBirth.timeIntervalSince1970, genre: mockGenre)

    }

}
