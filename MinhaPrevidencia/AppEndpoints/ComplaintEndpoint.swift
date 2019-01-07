//
//  ComplaintEndpoint.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

enum ComplaintApi {
    case getAll
    case get(uuid: String)
    case create(object: Complaint)
}

extension ComplaintApi: RemoteEndpoint {

    var resourcePath: String { return "complaint" }

    var path: URL {

        switch self {
        case .getAll: return self.baseURL.appendingPathComponent(self.resourcePath)
        case .get(let uuid): return self.baseURL.appendingPathComponent(self.resourcePath).appendingPathComponent(uuid)
        case .create: return self.baseURL.appendingPathExtension(self.resourcePath)
        }

    }

    var method: HTTPMethod {
        switch self {
        case .getAll: return .get
        case .get: return .get
        case .create: return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .getAll: return .request
        case .get: return .request
        case .create(let object): return .requestWithBody(body: object, urlParameters: nil, additionHeaders: nil)
        }
    }

    var headers: HTTPHeaders? { return nil }

}
