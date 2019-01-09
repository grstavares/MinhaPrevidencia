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

    func testGetById_returning200HttpResponse_OK() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        _ = try router.request(UserProfileApi.get(uuid: UserProfileEndpointTest.uuidAOnDb, authToken: nil)) { (data, response, error) in

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
        _ = try router.request(UserProfileApi.get(uuid: "InvalidUUID", authToken: nil)) { (data, response, error) in

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
        let mockObject = UserProfile(uuid: UserProfileEndpointTest.uuidAOnDb, firstName: "First and Middle", lastName: "second middle and Last", username: "username", birthDate: Date(), genre: "U")
        _ = try router.request(UserProfileApi.update(object: mockObject, authToken: nil)) { (data, response, error) in

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
        let mockObject = UserProfile(uuid: "invalidUUID", firstName: "Frist", lastName: "Last", username: "username", birthDate: Date(), genre: "U")
        _ = try router.request(UserProfileApi.update(object: mockObject, authToken: nil)) { (data, response, error) in

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
            UserProfileApi.get(uuid: UserProfileEndpointTest.uuidAOnDb, authToken: nil).path: UserProfileEndpointTest.objectA.asJsonData()!,
            UserProfileApi.get(uuid: UserProfileEndpointTest.uuidBOnDb, authToken: nil).path: UserProfileEndpointTest.objectB.asJsonData()!
        ]

    }

     static let uuidAOnDb = "123akj121ahsfkjdshu6543"
     static let uuidBOnDb = "1asdasjahfdsfkjdshu6543"
     static let objectA = UserProfile(uuid: UserProfileEndpointTest.uuidAOnDb, firstName: "Frist", lastName: "Last", username: "username", birthDate: Date(), genre: "U")
     static let objectB = UserProfile(uuid: UserProfileEndpointTest.uuidBOnDb, firstName: "Frist", lastName: "Last", username: "username", birthDate: Date(), genre: "U")

}
