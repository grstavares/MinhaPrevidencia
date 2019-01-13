//
//  FinancialEntryEndpoint.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 13/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

enum FinancialEntryApi {
    case getAll(authToken: String?)
    case get(uuid: String, authToken: String?)
}

extension FinancialEntryApi: RemoteEndpoint {

    var resourcePath: String { return "financial" }

    var path: URL {

        switch self {
        case .getAll: return self.baseURL.appendingPathComponent(self.resourcePath)
        case .get(let uuid, _): return self.baseURL.appendingPathComponent(self.resourcePath).appendingPathComponent(uuid)
        }

    }

    var method: HTTPMethod {
        switch self {
        case .getAll: return .get
        case .get: return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getAll: return .request
        case .get: return .request
        }
    }

    var headers: HTTPHeaders? { return nil }

}
