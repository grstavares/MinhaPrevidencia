//
//  AppNetwork.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
class AppRouter: NetworkManager {

    private var session: URLSession
    private var task: URLSessionTask?
    private var cachePolicy: URLRequest.CachePolicy
    private var timeout: TimeInterval
    private var defaultHeaders: HTTPHeaders = [:]

    init(session: URLSession, cachePolicy: URLRequest.CachePolicy = .reloadRevalidatingCacheData, timeout: TimeInterval = 10.0) {

        self.session = session
        self.cachePolicy = cachePolicy
        self.timeout = timeout

    }

    func request(_ route: RemoteEndpoint, completion: @escaping NetworkRouterCompletion) {

        do {

            let request = try self.buildRequest(from: route)
            self.task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })

        } catch { completion(nil, nil, error) }

        self.task?.resume()

    }

    func cancel() { self.task?.cancel() }

    private func buildRequest(from route: RemoteEndpoint) throws -> URLRequest {

        let builder = URLRequestBuilder(url: route.path, cachePolicy: self.cachePolicy, timeout: self.timeout).withMethod(route.method)

        switch route.task {

        case .request:

            var myHeaders: HTTPHeaders = [:]
            for (key, value) in self.defaultHeaders { myHeaders[key] = value }
            myHeaders["Content-Type"] = "application/json"

            return builder.withHeaders(myHeaders).build()

        case .requestWithParameters(let urlParameters, let additionalHeaders):

            var myHeaders: HTTPHeaders = [:]
            for (key, value) in self.defaultHeaders { myHeaders[key] = value }
            if let newHeaders = additionalHeaders { for (key, value) in newHeaders { myHeaders[key] = value } }

            return builder.withHeaders(myHeaders).withParameters(urlParameters).build()

        case .requestWithBody(let object, let urlParameters, let additionalHeaders):

            var myHeaders: HTTPHeaders = [:]
            for (key, value) in self.defaultHeaders { myHeaders[key] = value }
            if let newHeaders = additionalHeaders { for (key, value) in newHeaders { myHeaders[key] = value } }
            myHeaders["Content-Type"] = "application/json"

            let objectData = object?.asJsonData()

            return builder.withHeaders(myHeaders).withParameters(urlParameters).withBody(objectData).build()

        }

    }

    private class URLRequestBuilder {

        let url: URL
        let cachePolicy: URLRequest.CachePolicy
        let timeout: TimeInterval
        var method: HTTPMethod?
        var headers: HTTPHeaders = [:]
        var urlParameters: HTTPParameters = [:]
        var body: Data?

        init(url: URL, cachePolicy: URLRequest.CachePolicy, timeout: TimeInterval) {
            self.url = url
            self.cachePolicy = cachePolicy
            self.timeout = timeout
        }

        func withMethod(_ method: HTTPMethod) -> URLRequestBuilder {
            self.method = method
            return self
        }

        func withHeaders(_ newHeaders: HTTPHeaders?) -> URLRequestBuilder {
            if let headers = newHeaders { self.headers = headers }
            return self
        }

        func withParameters(_ newParams: HTTPParameters?) -> URLRequestBuilder {
            if let params = newParams { self.urlParameters = params }
            return self
        }

        func withBody(_ data: Data?) -> URLRequestBuilder {
            self.body = data
            return self
        }

        func build() -> URLRequest {

            var request = URLRequest(url: self.url, cachePolicy: self.cachePolicy, timeoutInterval: self.timeout)
            request.httpMethod = self.method?.rawValue

            for (key, value) in self.headers { request.setValue(value, forHTTPHeaderField: key) }

            if var urlComponents = URLComponents(url: self.url, resolvingAgainstBaseURL: false) {

                for (key, value) in self.urlParameters {
                    let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                    urlComponents.queryItems?.append(queryItem)
                }

                request.url = urlComponents.url

            }

            if let data = self.body {
                request.httpBody = data
            }

            return request

        }

    }

}
