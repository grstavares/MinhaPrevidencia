//
//  UserProfileEndpointTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class UserProfileEndpointTest: XCTestCase {

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
        router.request(UserProfileApi.get(uuid: UserProfileEndpointTest.uuidAOnDb)) { (data, response, error) in

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
        router.request(UserProfileApi.get(uuid: "InvalidUUID")) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data With a 404 Response"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testUpdate_returning200HttpResponse_Ok() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectPut = expectation(description: "Get 200 Status Code Return")
        let mockObject = UserProfile(uuid: UserProfileEndpointTest.uuidAOnDb, firstName: "First and Middle", lastName: "second middle and Last", username: "username", birthDate: Date(), genre: "U")
        router.request(UserProfileApi.update(object: mockObject)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectPut.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testUpdate_returning404HttpResponse_NotFound() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectPut = expectation(description: "Get 404 Status Code Return")
        let mockObject = UserProfile(uuid: "invalidUUID", firstName: "Frist", lastName: "Last", username: "username", birthDate: Date(), genre: "U")
        router.request(UserProfileApi.update(object: mockObject)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data when must return nil"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectPut.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    private func stubbedData() -> [URL: Data] {

        return [
            UserProfileApi.get(uuid: UserProfileEndpointTest.uuidAOnDb).path: UserProfileEndpointTest.objectA.asJsonData()!,
            UserProfileApi.get(uuid: UserProfileEndpointTest.uuidBOnDb).path: UserProfileEndpointTest.objectB.asJsonData()!
        ]

    }

    private static let uuidAOnDb = "123akj121ahsfkjdshu6543"
    private static let uuidBOnDb = "1asdasjahfdsfkjdshu6543"
    private static let objectA = UserProfile(uuid: UserProfileEndpointTest.uuidAOnDb, firstName: "Frist", lastName: "Last", username: "username", birthDate: Date(), genre: "U")
    private static let objectB = UserProfile(uuid: UserProfileEndpointTest.uuidBOnDb, firstName: "Frist", lastName: "Last", username: "username", birthDate: Date(), genre: "U")

}