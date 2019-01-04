//
//  InstitutionEndpoint.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
enum InstitutionEndpoint {
    case get(uuid: String)
    case update(object: Institution)
}

extension InstitutionEndpoint: RemoteEndpoint {

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
        case .get(let uuid): return self.baseURL.appendingPathComponent(uuid)
        case .update(let object): return self.baseURL.appendingPathComponent(object.uuid)
        }

    }

    var method: HTTPMethod {

        switch self {
        case .get: return .get
        case .update: return .put
        }

    }

    var task: HTTPTask {

        switch self {
        case .get: return .request
        case .update(let object):  return .request //return .requestJSONBody(body: object.raw(), urlParameters: nil, additionHeaders: nil)
        }

    }

    var headers: HTTPHeaders? { return nil }

}
