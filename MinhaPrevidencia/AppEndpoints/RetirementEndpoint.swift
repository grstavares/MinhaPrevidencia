//
//  RetirementEndpoint.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 04/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

enum RetirementApi {
    case getByUser(uuid: String)
}

extension RetirementApi: RemoteEndpoint {

    var resourcePath: String { return "retirement" }

    var path: URL {

        switch self {
        case .getByUser(let uuid):

            return self.baseURL
                .appendingPathComponent(self.resourcePath)
                .appendingPathComponent(uuid)

        }

    }

    var method: HTTPMethod { return .get }

    var task: HTTPTask { return .request }

    var headers: HTTPHeaders? { return nil }

}
