//
//  MockedSettings.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
@testable import MinhaPrevidencia

class MockedSettings: SettingsManager {
    var lastLoggedUserId: String { return UserProfileEndpointTest.uuidAOnDb }
    var institutionId: String { return InstitutionEndpointTest.uuidAOnDb }
    var poolingInterval: TimeInterval { return TimeInterval(1) }
    var networkTimeOut: TimeInterval { return TimeInterval(3) }
}
