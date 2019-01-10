//
//  InstitutionEndpointTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class InstitutionEndpointTest: XCTestCase {

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

    func testGetById_returning200HttpResponse_OK() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        _ = try router.request(InstitutionApi.get(uuid: InstitutionEndpointTest.uuidAOnDb, authToken: nil)) { (data, response, error) in

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
        _ = try router.request(InstitutionApi.get(uuid: "InvalidUUID", authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data With a 404 Response"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testUpdate_returning200HttpResponse_Ok() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectPut = expectation(description: "Get 200 Status Code Return")
        let mockObject = Institution(uuid: InstitutionEndpointTest.uuidAOnDb, name: "Updated Name")
        _ = try router.request(InstitutionApi.update(object: mockObject, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectPut.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testUpdate_returning404HttpResponse_NotFound() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectPut = expectation(description: "Get 404 Status Code Return")
        let mockObject = Institution(uuid: "invalidUUID", name: "NewName")
        _ = try router.request(InstitutionApi.update(object: mockObject, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data when must return nil"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectPut.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

     func stubbedData() -> [URL: Data] {

        return [
            InstitutionApi.get(uuid: InstitutionEndpointTest.uuidAOnDb, authToken: nil).path: InstitutionEndpointTest.objectA.asJsonData()!,
            InstitutionApi.get(uuid: InstitutionEndpointTest.uuidBOnDb, authToken: nil).path: InstitutionEndpointTest.objectB.asJsonData()!
        ]

    }

     static let uuidAOnDb = AppDelegate.institutionId
     static let uuidBOnDb = "1asdasjahfdsfkjdshu6543"
     static let objectA = Institution(uuid: uuidAOnDb, name: "InstitutionA")
     static let objectB = Institution(uuid: uuidBOnDb, name: "InstitutionA")

}
