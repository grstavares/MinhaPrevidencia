//
//  AppError.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 11/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
protocol AppError: Error {
    var code: String { get }
    var details: String? { get }
}
