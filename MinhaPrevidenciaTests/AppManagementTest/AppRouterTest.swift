//
//  AppRouterTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 06/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class AppRouterTest: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func testMockApiGet() {

        let validator: (URLRequest) -> (Data?, URLResponse?, Error?) = {request in

            let mut = TestApi.get
            if let method = request.httpMethod, method == mut.method.rawValue, request.httpBody == nil {
                let httpResponse = HTTPURLResponse(url: mut.path, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: [:])
                let resultData = Data("Request conforms expected".utf8)
                return (resultData, httpResponse, nil)
            } else { return (nil, nil, URLSessionMock.Errors.invalidMethod) }

        }

        let session = URLSessionMock(validator: validator)
        let router = AppRouter(session: session)

        let expectDownload = expectation(description: "Downloaded Data")
        router.request(TestApi.get) { (data, response, error) in

            if error != nil {XCTFail("Error is Not Nil")}
            if data == nil { XCTFail("Data is not equal original") }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 { expectDownload.fulfill()
            } else { XCTFail("Invalid URL Response") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testMockApiPost() {

        let validator: (URLRequest) -> (Data?, URLResponse?, Error?) = {request in

            let mut = TestApi.post
            if let method = request.httpMethod, method == mut.method.rawValue, request.httpBody != nil {
                let httpResponse = HTTPURLResponse(url: mut.path, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: [:])
                let resultData = Data("Request conforms expected".utf8)
                return (resultData, httpResponse, nil)
            } else { return (nil, nil, URLSessionMock.Errors.invalidMethod) }

        }

        let session = URLSessionMock(validator: validator)
        let router = AppRouter(session: session)

        let expectDownload = expectation(description: "Downloaded Data")
        router.request(TestApi.post) { (data, response, error) in

            if error != nil {XCTFail("Error is Not Nil")}
            if data == nil { XCTFail("Data is not equal original") }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 { expectDownload.fulfill()
            } else { XCTFail("Invalid URL Response") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testMockApiPut() {

        let validator: (URLRequest) -> (Data?, URLResponse?, Error?) = {request in

            let mut = TestApi.put
            if let method = request.httpMethod, method == mut.method.rawValue, request.httpBody != nil {
                let httpResponse = HTTPURLResponse(url: mut.path, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: [:])
                let resultData = Data("Request conforms expected".utf8)
                return (resultData, httpResponse, nil)
            } else { return (nil, nil, URLSessionMock.Errors.invalidMethod) }

        }

        let session = URLSessionMock(validator: validator)
        let router = AppRouter(session: session)

        let expectDownload = expectation(description: "Downloaded Data")
        router.request(TestApi.put) { (data, response, error) in

            if error != nil {XCTFail("Error is Not Nil")}
            if data == nil { XCTFail("Data is not equal original") }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 { expectDownload.fulfill()
            } else { XCTFail("Invalid URL Response") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testMockApiDelete() {

        let validator: (URLRequest) -> (Data?, URLResponse?, Error?) = {request in

            let mut = TestApi.delete
            if let method = request.httpMethod, method == mut.method.rawValue, request.httpBody == nil {
                let httpResponse = HTTPURLResponse(url: mut.path, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: [:])
                let resultData = Data("Request conforms expected".utf8)
                return (resultData, httpResponse, nil)
            } else { return (nil, nil, URLSessionMock.Errors.invalidMethod) }

        }

        let session = URLSessionMock(validator: validator)
        let router = AppRouter(session: session)

        let expectDownload = expectation(description: "Downloaded Data")
        router.request(TestApi.delete) { (data, response, error) in

            if error != nil {XCTFail("Error is Not Nil")}
            if data == nil { XCTFail("Data is not equal original") }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 { expectDownload.fulfill()
            } else { XCTFail("Invalid URL Response") }

        }

        waitForExpectations(timeout: 5, handler: nil)

    }

}

enum TestApi {
    case get
    case post
    case put
    case delete
}

extension TestApi: RemoteEndpoint {

    var path: URL { return URL(string: "https://www.endpoint.test")! }

    var method: HTTPMethod {
        switch self {
        case .get: return HTTPMethod.get
        case .post: return HTTPMethod.post
        case .put: return HTTPMethod.put
        case .delete: return HTTPMethod.delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .get: return .request
        case .post: return .requestWithBody(body: TestObject(name: "value"), urlParameters: nil, additionHeaders: nil)
        case .put: return .requestWithBody(body: TestObject(name: "value"), urlParameters: nil, additionHeaders: nil)
        case .delete: return .request
        }
    }

    var headers: HTTPHeaders? { return nil }

}

struct TestObject {
    let name: String
}

extension TestObject: Codable, JsonConvertible {

    init?(from data: Data) {
        let decoder = JSONDecoder()
        if let object = try? decoder.decode(TestObject.self, from: data) {
            self.name = object.name
        } else {return  nil}
    }

    func asJsonData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }

}
