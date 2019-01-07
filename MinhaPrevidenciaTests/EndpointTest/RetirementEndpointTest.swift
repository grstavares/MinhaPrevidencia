//
//  RetirementEndpointTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class RetirementEndpointTest: XCTestCase {

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

    func testGetById_returning200HttpResponse_OK() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        router.request(RetirementApi.getByUser(uuid: RetirementEndpointTest.uuidOnDb)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testGetById_returning404HttpResponse_NotFound() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 404 Status Code Return")
        router.request(RetirementApi.getByUser(uuid: "InvalidUUID")) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data With a 404 Response"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    private func stubbedData() -> [URL: Data] { return [RetirementApi.getByUser(uuid: RetirementEndpointTest.uuidOnDb).path: RetirementEndpointTest.object.asJsonData()! ] }

    private static let uuidOnDb = "123akj121107f654shuaa43"
    private static let object = Retirement(uuid: RetirementEndpointTest.uuidOnDb, startDate: Date(), endDate: Date(), contributions: [], withdrawals: [])

}
