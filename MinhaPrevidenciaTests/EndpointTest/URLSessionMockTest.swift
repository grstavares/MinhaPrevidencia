//
//  TestURLProtocolMock.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 06/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest

class URLSessionMockTest: XCTestCase {

    let url = URL(string: "https://www.url.com")!
    var session: URLSessionMock?

    override func setUp() {

        // Setup our objects

        let validator: (URL) -> (Data?, URLResponse?, Error?) = {receivedUrl in

            if receivedUrl == self.url {
                let httpResponse = HTTPURLResponse(url: receivedUrl, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: [:])
                let resultData = Data("GET Mehotd Received".utf8)
                return (resultData, httpResponse, nil)
            } else { return (nil, nil, URLSessionMock.Errors.invalidUrl) }

        }

        self.session = URLSessionMock(validator: validator)

    }

    override func tearDown() { }

    func testURLSessionMock() {

        // Perform the request and verify the result
        let expectDownload = expectation(description: "Downloaded Data")
        self.session?.dataTask(with: self.url) { (data, response, error) in

            if let error = error { XCTFail(error.localizedDescription) }
            if data == nil { XCTFail("Data is Not Equal Original") }
            if response == nil { XCTFail("Response is Nil") }
            expectDownload.fulfill()

        }.resume()

        waitForExpectations(timeout: 5, handler: nil)

    }

}
