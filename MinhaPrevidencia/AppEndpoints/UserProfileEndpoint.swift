//
//  UserProfileEndpoint.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 04/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

enum UserProfileApi {
    case get(uuid: String, authToken: String?)
    case update(object: UserProfile, authToken: String?)
}

extension UserProfileApi: RemoteEndpoint {

    var resourcePath: String { return "userprofile" }

    var path: URL {

        switch self {
        case .get(let uuid, _): return self.baseURL.appendingPathComponent(self.resourcePath).appendingPathComponent(uuid)
        case .update(let object, _): return self.baseURL.appendingPathComponent(self.resourcePath).appendingPathComponent(object.uuid)
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
        case .update(let object, _):  return .requestWithBody(body: object, urlParameters: nil, additionHeaders: nil)
        }

    }

    var headers: HTTPHeaders? { return nil }

}
