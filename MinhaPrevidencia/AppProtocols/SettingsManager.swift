//
//  SettingsManager.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
protocol SettingsManager {

    var institutionId: String { get }
    var lastLoggedUserId: String { get }

    var poolingInterval: TimeInterval { get }
    var networkTimeOut: TimeInterval { get }

}
