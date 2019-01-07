//
//  RemoteRouter.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

public enum Result<String> {
    case success
    case failure(String)
}

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

public protocol JsonConvertible {

    init?(from data: Data)
    func asJsonData() -> Data?

}

public protocol NetworkManager {

    func request(_ route: RemoteEndpoint, completion: @escaping NetworkRouterCompletion)
    func cancel()

}

public extension NetworkManager {

    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

public protocol RemoteEndpoint {

    var baseURL: URL { get }
    var path: URL { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }

    var environment: RemoteEnvironment { get }

}

public enum RemoteEnvironment {
    case development, staging, quality, production
}

public typealias HTTPParameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public enum HTTPTask {

    case request
    case requestWithParameters(urlParameters: HTTPParameters?, additionHeaders: HTTPHeaders?)
    case requestWithBody(body: JsonConvertible?, urlParameters: HTTPParameters?, additionHeaders: HTTPHeaders?)

}

public enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}
