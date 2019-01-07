//
//  NewsMessageEndpoint.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 04/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

enum NewsReportApi {
    case getAll
    case get(uuid: String)
    case markReaded(object: NewsReport)
}

extension NewsReportApi: RemoteEndpoint {

    var resourcePath: String { return "newsmessage" }

    var path: URL {

        switch self {
        case .getAll:

            return self.baseURL
                .appendingPathComponent(self.resourcePath)

        case .get(let uuid):

            return self.baseURL
                .appendingPathComponent(self.resourcePath)
                .appendingPathComponent(uuid)

        case .markReaded(let object):

            return self.baseURL
                .appendingPathComponent(self.resourcePath)
                .appendingPathComponent(object.uuid)
                .appendingPathComponent("readed")

        }

    }

    var method: HTTPMethod {

        switch self {
        case .getAll: return .get
        case .get: return .get
        case .markReaded: return .post
        }

    }

    var task: HTTPTask {
        switch self {
        case .getAll: return .request
        case .get: return .request
        case .markReaded(let object): return .requestWithBody(body: object, urlParameters: nil, additionHeaders: nil)
        }
    }

    var headers: HTTPHeaders? { return nil }

}
