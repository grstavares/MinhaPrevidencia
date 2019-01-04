//
//  DocumentEndpoint.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

enum DocumentApi {
    case getAll
    case get(uuid: String)
    case getContent(document: Document)
}

extension DocumentApi: RemoteEndpoint {

    var baseURL: URL {

        var stringUrl: String
        switch self.environment {
        case .development: stringUrl = "https://dev.endpoint.com"
        case .quality: stringUrl = "https://dev.endpoint.com"
        case .staging: stringUrl = "https://dev.endpoint.com"
        case .production: stringUrl = "https://dev.endpoint.com"
        }

        if let url = URL(string: stringUrl) {return url
        } else { fatalError("RemoteEndpoint Not Configured! \(#file), \(#line)") }

    }

    var path: URL {

        switch self {
        case .getAll: return self.baseURL
        case .get(let uuid): return self.baseURL.appendingPathComponent(uuid)
        case .getContent(let document): return document.url
        }

    }

    var method: HTTPMethod { return .get }

    var task: HTTPTask { return .request }

    var headers: HTTPHeaders? { return nil }

}
