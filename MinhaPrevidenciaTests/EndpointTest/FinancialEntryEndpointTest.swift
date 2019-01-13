//
//  FinancialEntryEndpointTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 13/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class FinancialEntryEndpointTest: XCTestCase {

    var backend: BackendMock?
    var session: URLSession?
    var router: AppRouter?

    override func setUp() {

        let data = self.stubbedData()
        let backend = BackendMock(database: data)
        let session = MockedURLSession(validator: backend.validator)
        let router = AppRouter(session: session)

        self.backend = backend
        self.session = session
        self.router = router

    }

    override func tearDown() { }

    func testGetAll() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        _ = try router.request(FinancialEntryApi.getAll(authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testGetById_returning200HttpResponse_OK() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        _ = try router.request(FinancialEntryApi.get(uuid: FinancialEntryEndpointTest.uuidAOnDb, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testGetById_returning404HttpResponse_NotFound() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 404 Status Code Return")
        _ = try router.request(FinancialEntryApi.get(uuid: "InvalidUUID", authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data With a 404 Response"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func stubbedData() -> [URL: Data] {

        let encoder = JSONEncoder()

        var stubbed: [URL: Data] = [:]

        let array = [FinancialEntryEndpointTest.objectA.raw(), FinancialEntryEndpointTest.objectB.raw()]
        if let encoded = try? encoder.encode(array) {
            stubbed[FinancialEntryApi.getAll(authToken: nil).path] = encoded
        }

        stubbed[FinancialEntryApi.get(uuid: FinancialEntryEndpointTest.uuidAOnDb, authToken: nil).path] = FinancialEntryEndpointTest.objectA.asJsonData()!
        stubbed[FinancialEntryApi.get(uuid: FinancialEntryEndpointTest.uuidBOnDb, authToken: nil).path] = FinancialEntryEndpointTest.objectB.asJsonData()!

        return stubbed

    }

    static let uuidAOnDb = "123akj121ahsfkjdshu6543"
    static let uuidBOnDb = "1asdasjahfdsfkjdshu6543"
    static let objectA = FinancialEntry(uuid: FinancialEntryEndpointTest.uuidAOnDb, date: Date(), period: FinancialEntryEndpointTest.range, subject: "Subject", description: "description", value: 456.98, details: nil, isIncome: false, entryCategory: nil, wasDeleted: false)
    static let objectB = FinancialEntry(uuid: FinancialEntryEndpointTest.uuidBOnDb, date: Date(), period: FinancialEntryEndpointTest.range, subject: "Subject", description: "description", value: 456.98, details: nil, isIncome: false, entryCategory: nil, wasDeleted: false)

    static var range: ClosedRange<Date> {

        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let range = Calendar.current.range(of: .day, in: .month, for: Date())!

        let mockStart = DateComponents(
            calendar: Calendar.current, timeZone: TimeZone.current,
            era: nil,
            year: dateComponents.year, month: dateComponents.month, day: 1,
            hour: 0, minute: 0, second: 0, nanosecond: 0,
            weekday: nil, weekdayOrdinal: nil, quarter: nil,
            weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
            ).date!

        let mockEnd = DateComponents(
            calendar: Calendar.current, timeZone: TimeZone.current,
            era: nil,
            year: dateComponents.year, month: dateComponents.month, day: range.count,
            hour: 0, minute: 0, second: 0, nanosecond: 0,
            weekday: nil, weekdayOrdinal: nil, quarter: nil,
            weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
            ).date!

        return mockStart...mockEnd

    }

}
