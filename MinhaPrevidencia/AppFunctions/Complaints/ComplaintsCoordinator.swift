//
//  ComplaintsCoordinator.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 17/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum ComplaintsActions: AppCoordinatorAction {

    case selectComplaint(uuid: String)
    case createComplaint(uuid: String)
    case addComment(uuid: String)

    var mustBeSync: Bool { return !self.mustBeAsync }
    var mustBeAsync: Bool {
        switch self {
        case .selectComplaint: return false
        case .createComplaint: return true
        case .addComment: return true
        }
    }

    var debugName: String {
        switch self {
        case .selectComplaint(let uuid): return "SelectComplaint -> \(uuid)"
        case .createComplaint(let uuid): return "CreateComplaint -> \(uuid)"
        case .addComment(let uuid): return "AddComment -> \(uuid)"
        }
    }

}

class ComplaintsCoordinator: AppCoordinator {

    let appState: AppState
    let mainCoordinator: AppCoordinator

    init(mainCoordinator: AppCoordinator, appState: AppState) {

        self.mainCoordinator = mainCoordinator
        self.appState = appState

    }

    func initialVC() -> UIViewController {

        guard let controller = ComplaintsVC.instantiate(with: self, state: self.appState) else {
            AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "ComplaintsVC"))
            fatalError("Unable to Load Initial ViewController")
        }

        return controller

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController) {

        if action.mustBeAsync { return }

        switch action {
        case ComplaintsActions.selectComplaint(let uuid): self.selectComplaint(uuid: uuid)
        case ComplaintsActions.createComplaint (let uuid): self.createComplaint(uuid: uuid)
        case ComplaintsActions.addComment(let uuid): self.addComment(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController, with: (Bool) -> Void) {

        if action.mustBeSync { return }

        switch action {
        case ComplaintsActions.selectComplaint(let uuid): self.selectComplaint(uuid: uuid)
        case ComplaintsActions.createComplaint (let uuid): self.createComplaint(uuid: uuid)
        case ComplaintsActions.addComment(let uuid): self.addComment(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    private func selectComplaint(uuid: String) {

    }

    private func createComplaint(uuid: String) {

    }

    private func addComment(uuid: String) {

    }

}
