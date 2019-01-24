//
//  AppErrorHandling.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 11/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

extension AppDelegate {

    enum OperationErrors: AppError {

        case canNotLoadViewController(name: String)
        case canNotCreateFile(filename: String)
        case canNotPersistFileOnDisk
        case canNotParseDocument(data: Data)

        var code: String {
            switch self {
            case .canNotLoadViewController: return "CanNotLoadViewController"
            case .canNotCreateFile: return "CanNotCreateFile"
            case .canNotPersistFileOnDisk: return "CanNotPersistFileOnDisk"
            case .canNotParseDocument: return "CanNotParseDocument"
            }
        }

        var details: String? {
            switch self {
            case .canNotLoadViewController(let vcName): return "CanNotLoadViewController -> \(vcName)"
            case .canNotCreateFile(let filename): return "canNotCreateFile -> \(filename)"
            case .canNotPersistFileOnDisk: return "canNotPersistFIleOnDisk"
            case .canNotParseDocument: return "canNotParseDocument"
            }
        }

    }

    static func handleError(error: Swift.Error, file: String = #file, line: Int = #line) {
        print("=================================== ERROR =================================== ")
        print("ERROR IN \(file), line \(line)")
        print(error.localizedDescription)
    }

}
