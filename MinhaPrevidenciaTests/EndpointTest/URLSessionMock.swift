//
//  URLSessionMock.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 06/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
@testable import MinhaPrevidencia
// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {

    enum Errors: Error {
        case invalidMethod
        case invalidBody
        case invalidHeaders
        case invalidUrl
    }

    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    typealias RequestMatcher = (URLRequest) -> (Data?, URLResponse?, Error?)
    typealias URLMatcher = (URL) -> (Data?, URLResponse?, Error?)

    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?
    var requestMatcher: RequestMatcher?
    var urlMatcher: URLMatcher?

    init(validator: @escaping RequestMatcher) {
        self.requestMatcher = validator
    }

    init(validator: @escaping URLMatcher) {
        self.urlMatcher = validator
    }

    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler ) -> URLSessionDataTask {

        return URLSessionDataTaskMock {
            if let result = self.urlMatcher?(url) {
                let (data, response, error) = result
                completionHandler(data, response, error)
            } else { completionHandler(nil, nil, nil) }
        }

    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler ) -> URLSessionDataTask {

        return URLSessionDataTaskMock {

            if let result = self.requestMatcher?(request) {
                let (data, response, error) = result
                completionHandler(data, response, error)
            } else { completionHandler(nil, nil, nil) }

        }

    }

}

class BackendMock {

    var database: [URL: Data]

    init(database: [URL: Data]) {
        self.database = database
    }

    // swiftlint:disable large_tuple
    // swiftlint:disable cyclomatic_complexity
    func validator(request: URLRequest) -> (Data?, URLResponse?, Error?) {

        guard let url = request.url else {
            return (nil, nil, URLSessionMock.Errors.invalidUrl)
        }

        guard let method = request.httpMethod else {
            return (nil, nil, URLSessionMock.Errors.invalidMethod)
        }

        switch method {

        case HTTPMethod.get.rawValue:

            guard let found = database[url] else {
                let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "HTTP 1.1", headerFields: [:])
                return (nil, response, nil)
            }

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: [:])
            return (found, response, nil)

        case HTTPMethod.put.rawValue:

            guard database[url] != nil else {
                let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "HTTP 1.1", headerFields: [:])
                return (nil, response, nil)
            }

            guard let data = request.httpBody else {
                let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: "HTTP 1.1", headerFields: [:])
                return (nil, response, nil)
            }

            database[url] = data

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: [:])
            return (data, response, nil)

        case HTTPMethod.delete.rawValue:

            guard database[url] != nil else {
                let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "HTTP 1.1", headerFields: [:])
                return (nil, response, nil)
            }

            database.removeValue(forKey: url)

            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: [:])
            return (nil, response, nil)

        case HTTPMethod.post.rawValue:

            guard let data = request.httpBody else {
                let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: "HTTP 1.1", headerFields: [:])
                return (nil, response, nil)
            }

            let newId = UUID().uuidString
            let newUrl = url.appendingPathComponent(newId)
            database[newUrl] = data

            let response = HTTPURLResponse(url: url, statusCode: 201, httpVersion: "HTTP 1.1", headerFields: ["Location": newUrl.absoluteString])
            return (data, response, nil)

        default:

            return (nil, nil, nil)

        }

    }

}
