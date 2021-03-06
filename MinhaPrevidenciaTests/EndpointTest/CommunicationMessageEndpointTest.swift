//
//  ComunicationMessageEndpoint.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class CommunicationMessageEndpointTest: XCTestCase {

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
        _ = try router.request(CommunicationMessageApi.getAll(authToken: nil)) { (data, response, error) in

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
        _ = try router.request(CommunicationMessageApi.get(uuid: CommunicationMessageEndpointTest.uuidAOnDb, authToken: nil)) { (data, response, error) in

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
        _ = try router.request(CommunicationMessageApi.get(uuid: "InvalidUUID", authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data With a 404 Response"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testCreate_returning201HttpResponse_Created() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 201 Status Code Return")
        let mockObject = CommunicationMessage(uuid: "NewId", title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        _ = try router.request(CommunicationMessageApi.create(object: mockObject, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            let headersKeys = httpResponse.allHeaderFields.keys
            if httpResponse.statusCode == 201, headersKeys.contains("Location") { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testUpdate_returning200HttpResponse_Ok() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        let mockObject = CommunicationMessage(uuid: CommunicationMessageEndpointTest.uuidAOnDb, title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        _ = try router.request(CommunicationMessageApi.update(object: mockObject, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testUpdate_returning404HttpResponse_NotFound() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 404 Status Code Return")
        let mockObject = CommunicationMessage(uuid: "InvalidUUID", title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        _ = try router.request(CommunicationMessageApi.update(object: mockObject, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data when must return nil"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testDelete_returning200HttpResponse_Ok() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        let mockObject = CommunicationMessage(uuid: CommunicationMessageEndpointTest.uuidAOnDb, title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        _ = try router.request(CommunicationMessageApi.delete(object: mockObject, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data when must return nil"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testDelete_returning404HttpResponse_NotFound() throws {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 404 Status Code Return")
        let mockObject = CommunicationMessage(uuid: "InvalidUUID", title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        _ = try router.request(CommunicationMessageApi.delete(object: mockObject, authToken: nil)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data when must return nil"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func stubbedData() -> [URL: Data] {

        let encoder = JSONEncoder()

        var stubbed: [URL: Data] = [:]

        let array = [CommunicationMessageEndpointTest.objectA.raw(), CommunicationMessageEndpointTest.objectB.raw()]
        if let encoded = try? encoder.encode(array) {
            stubbed[CommunicationMessageApi.getAll(authToken: nil).path] = encoded
        }

        stubbed[CommunicationMessageApi.get(uuid: CommunicationMessageEndpointTest.uuidAOnDb, authToken: nil).path] = CommunicationMessageEndpointTest.objectA.asJsonData()!
        stubbed[CommunicationMessageApi.get(uuid: CommunicationMessageEndpointTest.uuidBOnDb, authToken: nil).path] = CommunicationMessageEndpointTest.objectB.asJsonData()!

        return stubbed

    }

    static let uuidAOnDb = "123akj121ahsfkjdshu6543"
    static let uuidBOnDb = "1asdasjahfdsfkjdshu6543"
    static let objectA = CommunicationMessage(uuid: CommunicationMessageEndpointTest.uuidAOnDb, title: "Title", summary: "Summary", content: "content", dateCreation: Date(), userOrigin: "origin", recipients: ["first"])
    static let objectB = CommunicationMessage(uuid: CommunicationMessageEndpointTest.uuidBOnDb, title: "Title", summary: "Summary", content: "content", dateCreation: Date(), userOrigin: "origin", recipients: ["first"])

}
