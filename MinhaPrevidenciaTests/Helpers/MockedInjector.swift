//
//  MockedInjector.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData
@testable import MinhaPrevidencia

class MockedInjector: AppInjector {

    let session: URLSession
    let dataStoreManager: DataStoreManager

    init(session: URLSession, dataStoreManager: DataStoreManager) {
        self.session = session
        self.dataStoreManager = dataStoreManager
        super.init()
    }

    override func settings() -> SettingsManager? { return MockedSettings() }
    override func appRouter() -> NetworkManager? { return AppRouter(session: self.session) }
    override func authManager() -> AuthenticationManager? { return MockedAuthManager() }
    override func localStore() -> DataStoreManager? { return self.dataStoreManager }

}
