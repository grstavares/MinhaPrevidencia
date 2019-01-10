//
//  MockedAuthManager.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 10/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import MinhaPrevidencia

class MockedAuthManager: AuthenticationManager {

    var session: BehaviorSubject<UserSession> = BehaviorSubject(value: UserSession(uuid: UserProfileEndpointTest.uuidAOnDb, token: "nulttoken"))
    var isLogged: BehaviorRelay<Bool> = BehaviorRelay(value: true)

    func currentUser() -> UserProfile? { return UserProfileEndpointTest.objectA }

    func signIn(username: String, password: String) { }

    func signUp(userProfile: UserProfile, password: String) { }

    func signOut() { }

}
