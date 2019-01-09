//
//  RemoteRouter.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

public protocol JsonConvertible {

    init?(from data: Data)
    func asJsonData() -> Data?

}

public protocol NetworkManager {

    func request(_ route: RemoteEndpoint, completion: @escaping NetworkRouterCompletion) throws -> URLSessionTask

}

public extension NetworkManager {

    // swiftlint:disable cyclomatic_complexity
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, HTTPError> {

        let statusCode = response.statusCode
        switch statusCode {
        case 200...299: return Result.value(true)
        case 400: return Result.error(HTTPError.badRequest(statusCode: statusCode))
        case 401: return Result.error(HTTPError.unauthorized(statusCode: statusCode))
        case 402: return Result.error(HTTPError.paymentRequired(statusCode: statusCode))
        case 403: return Result.error(HTTPError.forbidden(statusCode: statusCode))
        case 404: return Result.error(HTTPError.notFound(statusCode: statusCode))
        case 405: return Result.error(HTTPError.methodNotAllowed(statusCode: statusCode))
        case 406...499: return Result.error(HTTPError.clientError(statusCode: statusCode))
        case 500...502: return Result.error(HTTPError.serverError(statusCode: statusCode))
        case 503: return Result.error(HTTPError.dependencyUnavailable(statusCode: statusCode))
        case 504...599: return Result.error(HTTPError.serverError(statusCode: statusCode))
        default: return Result.error(HTTPError.undefined(statusCode: statusCode))
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

public enum HTTPError: Error, Equatable, CustomStringConvertible {

    case unreachable(statusCode: Int)
    case badRequest(statusCode: Int)
    case unauthorized(statusCode: Int)
    case paymentRequired(statusCode: Int)
    case forbidden(statusCode: Int)
    case notFound(statusCode: Int)
    case methodNotAllowed(statusCode: Int)
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case dependencyUnavailable(statusCode: Int)
    case undefined(statusCode: Int)

    public var description: String {
        switch self {
        case .unreachable(let statusCode): return "Http Status Code \(statusCode) - Unreachable"
        case .badRequest(let statusCode): return "Http Status Code \(statusCode) - BadRequest"
        case .unauthorized(let statusCode): return "Http Status Code \(statusCode) - Unauthorized"
        case .paymentRequired(let statusCode): return "Http Status Code \(statusCode) - PaymentRequired"
        case .forbidden(let statusCode): return "Http Status Code \(statusCode) - Forbidden"
        case .notFound(let statusCode): return "Http Status Code \(statusCode) - NotFound"
        case .methodNotAllowed(let statusCode): return "Http Status Code \(statusCode) - MethodNotAllowed"
        case .clientError(let statusCode): return "Http Status Code \(statusCode) - ClientError"
        case .serverError(let statusCode): return "Http Status Code \(statusCode) - ServerError"
        case .dependencyUnavailable(let statusCode): return "Http Status Code \(statusCode) - Dependency Unavailable"
        case .undefined(let statusCode): return "Http Status Code \(statusCode) - Undefined"
        }
    }

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
