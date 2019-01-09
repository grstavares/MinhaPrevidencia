//
//  AuthenticationManager.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthenticationManager {

    var session: BehaviorSubject<UserSession> { get }
    var isLogged: BehaviorRelay<Bool> { get }
    func currentUser() -> UserProfile?
    func signIn(username: String, password: String)
    func signUp(userProfile: UserProfile, password: String)
    func signOut()

}

struct UserSession: Equatable {
    let uuid: String
    let token: String
}
