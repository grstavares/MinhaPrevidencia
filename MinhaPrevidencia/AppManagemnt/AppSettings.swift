//
//  AppSettings.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 09/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
class AppSettings: SettingsManager {

    var institutionId: String { return AppDelegate.institutionId }
    var lastLoggedUserId: String { return "" }

    var poolingInterval: TimeInterval { return TimeInterval(3 * 60) }
    var networkTimeOut: TimeInterval { return TimeInterval(6 * 60) }

}
