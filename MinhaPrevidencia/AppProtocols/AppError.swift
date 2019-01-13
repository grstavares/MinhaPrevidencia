//
//  AppError.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 11/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
protocol AppError: LocalizedError, CustomStringConvertible, CustomDebugStringConvertible {
    var code: String { get }
    var details: String? { get }
    var localizedDescription: String { get }
}

extension AppError {

    var description: String { return self.details ?? "NoDetails" }
    var debugDescription: String { return self.details ?? "NoDetails" }
    var localizedDescription: String { return self.details ?? "NoDetails" }

}

extension LocalizedError where Self: CustomStringConvertible {

    var errorDescription: String? {
        return description
    }

}
