//
//  ComunicationMessageEndpoint.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 04/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

enum CommunicationMessageApi {

    case getAll(authToken: String?)
    case get(uuid: String, authToken: String?)
    case create(object: CommunicationMessage, authToken: String?)
    case update(object: CommunicationMessage, authToken: String?)
    case delete(object: CommunicationMessage, authToken: String?)
    case send(object: CommunicationMessage, authToken: String?)
    case archive(object: CommunicationMessage, authToken: String?)

}

extension CommunicationMessageApi: RemoteEndpoint {

    var resourcePath: String { return "message" }

    var path: URL {

        switch self {

        case .getAll:

            return self.baseURL
                .appendingPathComponent(self.resourcePath)

        case .get(let uuid, _):

            return self.baseURL
                .appendingPathComponent(self.resourcePath)
                .appendingPathComponent(uuid)

        case .create:

            return self.baseURL
                .appendingPathComponent(self.resourcePath)

        case .update(let object, _):

            return self.baseURL
                .appendingPathComponent(self.resourcePath)
                .appendingPathComponent(object.uuid)

        case .delete(let object, _):

            return self.baseURL
                .appendingPathComponent(self.resourcePath)
                .appendingPathComponent(object.uuid)

        case .send(let object, _):

            return self.baseURL
                .appendingPathComponent(self.resourcePath)
                .appendingPathComponent(object.uuid)
                .appendingPathComponent("status")

        case .archive(let object, _):

            return self.baseURL
                .appendingPathComponent(self.resourcePath)
                .appendingPathComponent(object.uuid)
                .appendingPathComponent("status")

        }

    }

    var method: HTTPMethod {
        switch self {
        case .getAll: return .get
        case .get: return .get
        case .create: return .post
        case .update: return .put
        case .delete: return .delete
        case .send: return .post
        case .archive: return .post
        }
    }

    var task: HTTPTask {

        switch self {

        case .getAll:

            return .request

        case .get:

            return .request

        case .create(let object, _):

            return .requestWithBody(body: object, urlParameters: nil, additionHeaders: nil)

        case .update(let object, _):

            return .requestWithBody(body: object, urlParameters: nil, additionHeaders: nil)

        case .delete:

            let statusChange = StatusChangeOperation("DELETE")
            return .requestWithBody(body: statusChange, urlParameters: nil, additionHeaders: nil)

        case .send:

            let statusChange = StatusChangeOperation("SEND")
            return .requestWithBody(body: statusChange, urlParameters: nil, additionHeaders: nil)

        case .archive:

            let statusChange = StatusChangeOperation("ARCHIVE")
            return .requestWithBody(body: statusChange, urlParameters: nil, additionHeaders: nil)
        }

    }

    var headers: HTTPHeaders? { return nil }

    struct StatusChangeOperation: Codable, JsonConvertible {

        let operation: String

        init(_ operation: String) {
            self.operation = operation
        }

        init?(from data: Data) {

            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(StatusChangeOperation.self, from: data) {
                self.operation = decoded.operation
            } else { return nil }

        }

        func asJsonData() -> Data? {

            let encoder = JSONEncoder()
            return try? encoder.encode(self)

        }

    }

}
