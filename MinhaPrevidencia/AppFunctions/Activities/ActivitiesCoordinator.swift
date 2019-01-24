//
//  ActivitiesCoordinator.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum ActivitiesActions: AppCoordinatorAction {

    case selectActivity(uuid: String)

    var mustBeSync: Bool { return !self.mustBeAsync }
    var mustBeAsync: Bool { return false }

    var debugName: String {
        switch self {
        case .selectActivity(let uuid): return "SelectActivity -> \(uuid)"
        }
    }

}

class ActivitiesCoordinator: AppCoordinator {

    let appState: AppState
    let mainCoordinator: AppCoordinator

    init(mainCoordinator: AppCoordinator, appState: AppState) {

        self.mainCoordinator = mainCoordinator
        self.appState = appState

    }

    func initialVC() -> UIViewController {

        guard let controller = ActivitiesVC.instantiate(with: self, state: self.appState) else {
            AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "ActivitiesVC"))
            fatalError("Unable to Load Initial ViewController")
        }

        return controller

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController) {

        if action.mustBeAsync { return }

        switch action {
        case ActivitiesActions.selectActivity(let uuid): self.showActivity(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController, with: (Bool) -> Void) {

        if action.mustBeSync { return }

        switch action {
        case ActivitiesActions.selectActivity(let uuid): self.showActivity(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    private func showActivity(uuid: String) { }

}
