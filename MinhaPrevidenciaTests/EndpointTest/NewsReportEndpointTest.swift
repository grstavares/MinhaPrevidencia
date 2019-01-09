//
//  NewsMessageEndpointTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class NewsReportEndpointTest: XCTestCase {

    var backend: BackendMock?
    var session: URLSession?
    var router: AppRouter?

    override func setUp() {

        let data = self.stubbedData()
        let backend = BackendMock(database: data)
        let session = URLSessionMock(validator: backend.validator)
        let router = AppRouter(session: session)

        self.backend = backend
        self.session = session
        self.router = router

    }

    override func tearDown() { }

    func testGetAll() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        _ = try router.request(NewsReportApi.getAll(authToken: nil)) { (data, response, error) in

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
        _ = try router.request(NewsReportApi.get(uuid: NewsReportEndpointTest.uuidAOnDb, authToken: nil)) { (data, response, error) in

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
        _ = try router.request(NewsReportApi.get(uuid: "InvalidUUID", authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data With a 404 Response"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testMarRead_returning201HttpResponse_Created() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 201 Status Code Return")
        let mockObject = NewsReport(uuid: NewsReportEndpointTest.uuidAOnDb, title: "Title", contents: "contents", dateCreation: Date(), lastUpdate: nil, url: nil)
        _ = try router.request(NewsReportApi.markReaded(object: mockObject, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            let headersKeys = httpResponse.allHeaderFields.keys
            if httpResponse.statusCode == 201, headersKeys.contains("Location") { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

     func stubbedData() -> [URL: Data] {

        let encoder = JSONEncoder()

        var stubbed: [URL: Data] = [:]

        let array = [NewsReportEndpointTest.objectA.raw(), NewsReportEndpointTest.objectB.raw()]
        if let encoded = try? encoder.encode(array) {
            stubbed[NewsReportApi.getAll(authToken: nil).path] = encoded
        }

        stubbed[NewsReportApi.get(uuid: NewsReportEndpointTest.uuidAOnDb, authToken: nil).path] = NewsReportEndpointTest.objectA.asJsonData()!
        stubbed[NewsReportApi.get(uuid: NewsReportEndpointTest.uuidBOnDb, authToken: nil).path] = NewsReportEndpointTest.objectB.asJsonData()!

        return stubbed

    }

     static let uuidAOnDb = "123akj121ahsfkjdshu6543"
     static let uuidBOnDb = "1asdasjahfdsfkjdshu6543"
     static let objectA = NewsReport(uuid: NewsReportEndpointTest.uuidAOnDb, title: "Title", contents: "contents", dateCreation: Date(), lastUpdate: nil, url: nil)
     static let objectB = NewsReport(uuid: NewsReportEndpointTest.uuidBOnDb, title: "Title", contents: "contents", dateCreation: Date(), lastUpdate: nil, url: nil)

}
