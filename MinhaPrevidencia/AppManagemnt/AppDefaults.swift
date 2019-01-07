//
//  AppDefaults.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 04/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import SwiftSugarKit

extension AppDelegate {

    static let devUrl = "https://dev.endpoint.com"
    static let qaUrl = "https://qa.endpoint.com"
    static let stageUrl = "https://stage.endpoint.com"
    static let prodUrl = "https://prod.endpoint.com"

    static let initialDataKey = "InitialData"
    static let institutionId = "9876567d"

    enum OperationErrors: AppError {

        case canNotCreateFile
        case canNotPersistFileOnDisk
        case canNotParseDocument(data: Data)

        var code: String {
            switch self {
            case .canNotCreateFile: return "canNotCreateFile"
            case .canNotPersistFileOnDisk: return "canNotPersistFIleOnDisk"
            case .canNotParseDocument: return "canNotParseDocument"
            }
        }

    }

}

extension RemoteEndpoint {

    var environment: RemoteEnvironment {

        #if DEBUG
        return RemoteEnvironment.development
        #elseif QA
        return RemoteEnvironment.quality
        #elseif STAGE
        return RemoteEnvironment.staging
        #else
        return RemoteEnvironment.production
        #endif

    }

    var baseURL: URL {

        var stringUrl: String
        switch self.environment {
        case .development: stringUrl = AppDelegate.devUrl
        case .quality: stringUrl = AppDelegate.qaUrl
        case .staging: stringUrl = AppDelegate.stageUrl
        case .production: stringUrl = AppDelegate.prodUrl
        }

        if let url = URL(string: stringUrl) {return url
        } else { fatalError("RemoteEndpoint Not Configured! \(#file), \(#line)") }

    }

}
