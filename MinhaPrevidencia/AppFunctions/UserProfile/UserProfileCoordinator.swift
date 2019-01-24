//
//  UserProfileCoordinator.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum UserProfileAction: AppCoordinatorAction {

    case changePassword(String, String)
    case updateProfile(UserProfile)

    var mustBeSync: Bool { return !self.mustBeAsync }
    var mustBeAsync: Bool { return true }

    var debugName: String {
        switch self {
        case .changePassword: return "ChangePassword"
        case .updateProfile(let profile): return "UpdateProfile -> \(profile)"
        }
    }

}

class UserProfileCoordinator: AppCoordinator {

    let appState: AppState
    let mainCoordinator: AppCoordinator

    init(mainCoordinator: AppCoordinator, appState: AppState) {

        self.mainCoordinator = mainCoordinator
        self.appState = appState

    }

    func initialVC() -> UIViewController {

        guard let controller = UserProfileVC.instantiate(with: self, state: self.appState) else {
            AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "UserProfileVC"))
            fatalError("Unable to Load Initial ViewController")
        }

        return controller

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController) {

        if action.mustBeAsync { return }

        switch action {
        case UserProfileAction.changePassword: return
        case UserProfileAction.updateProfile: return
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController, with: (Bool) -> Void) {

        if action.mustBeSync { return }

        switch action {
        case UserProfileAction.changePassword: return
        case UserProfileAction.updateProfile: return
        default: mainCoordinator.perform(action: action, from: requester)}

    }

}
