//
//  AppErrorHandling.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 11/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation

extension AppDelegate {

    static func handleError(error: Swift.Error, file: String = #file, line: Int = #line) {
        print("=================================== ERROR =================================== ")
        print(error.localizedDescription)
    }

}
