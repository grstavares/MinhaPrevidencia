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
        let session = URLSessionMock(validator: backend.validator)
        let router = AppRouter(session: session)

        self.backend = backend
        self.session = session
        self.router = router

    }

//    case send(object: ComunicationMessage)
//    case archive(object: ComunicationMessage)

    override func tearDown() { }

    func testGetAll() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        router.request(CommunicationMessageApi.getAll) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testGetById_returning200HttpResponse_OK() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        router.request(CommunicationMessageApi.get(uuid: CommunicationMessageEndpointTest.uuidAOnDb)) { (data, response, error) in

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
        router.request(CommunicationMessageApi.get(uuid: "InvalidUUID")) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data With a 404 Response"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testCreate_returning201HttpResponse_Created() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 201 Status Code Return")
        let mockObject = CommunicationMessage(uuid: "NewId", title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        router.request(CommunicationMessageApi.create(object: mockObject)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            let headersKeys = httpResponse.allHeaderFields.keys
            if httpResponse.statusCode == 201, headersKeys.contains("Location") { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testUpdate_returning200HttpResponse_Ok() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        let mockObject = CommunicationMessage(uuid: CommunicationMessageEndpointTest.uuidAOnDb, title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        router.request(CommunicationMessageApi.update(object: mockObject)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data != nil else { XCTFail("AppRouter Returned Nil Data"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testUpdate_returning404HttpResponse_NotFound() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 404 Status Code Return")
        let mockObject = CommunicationMessage(uuid: "InvalidUUID", title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        router.request(CommunicationMessageApi.update(object: mockObject)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data when must return nil"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testDelete_returning200HttpResponse_Ok() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 200 Status Code Return")
        let mockObject = CommunicationMessage(uuid: CommunicationMessageEndpointTest.uuidAOnDb, title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        router.request(CommunicationMessageApi.delete(object: mockObject)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data when must return nil"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 200 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testDelete_returning404HttpResponse_NotFound() {

        guard let router = self.router else { XCTFail("Backend System not Configured!"); return }

        let expectGet = expectation(description: "Get 404 Status Code Return")
        let mockObject = CommunicationMessage(uuid: "InvalidUUID", title: "Title", summary: "Summary", content: "Content", dateCreation: Date(), userOrigin: "origin", recipients: ["recipient"])
        router.request(CommunicationMessageApi.delete(object: mockObject)) { (data, response, error) in

            guard error == nil else { XCTFail("AppRouter Error -> \(String(describing: error))"); return }
            guard data == nil else { XCTFail("AppRouter Returned Data when must return nil"); return }
            guard let httpResponse = response as? HTTPURLResponse else { XCTFail("AppRouter Returned with Invalid HttpResponse"); return }
            if httpResponse.statusCode == 404 { expectGet.fulfill()
            } else { XCTFail("AppRouter Returned with statusCode -> \(httpResponse.statusCode)") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    private func stubbedData() -> [URL: Data] {

        return [
            CommunicationMessageApi.getAll.path: CommunicationMessageEndpointTest.objectB.asJsonData()!,
            CommunicationMessageApi.get(uuid: CommunicationMessageEndpointTest.uuidAOnDb).path: CommunicationMessageEndpointTest.objectA.asJsonData()!,
            CommunicationMessageApi.get(uuid: CommunicationMessageEndpointTest.uuidBOnDb).path: CommunicationMessageEndpointTest.objectB.asJsonData()!
        ]

    }

    private static let uuidAOnDb = "123akj121ahsfkjdshu6543"
    private static let uuidBOnDb = "1asdasjahfdsfkjdshu6543"
    private static let objectA = CommunicationMessage(uuid: CommunicationMessageEndpointTest.uuidAOnDb, title: "Title", summary: "Summary", content: "content", dateCreation: Date(), userOrigin: "origin", recipients: ["first"])
    private static let objectB = CommunicationMessage(uuid: CommunicationMessageEndpointTest.uuidBOnDb, title: "Title", summary: "Summary", content: "content", dateCreation: Date(), userOrigin: "origin", recipients: ["first"])

}
