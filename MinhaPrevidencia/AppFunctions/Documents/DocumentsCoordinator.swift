//
//  DocumentsCoordinator.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum DocumentsActions: AppCoordinatorAction {

    case selectDocument(uuid: String)
    case markAsPrefered(uuid: String)
    case requestPermission(uuid: String)

    var mustBeSync: Bool { return !self.mustBeAsync }
    var mustBeAsync: Bool {
        switch self {
        case .selectDocument: return false
        case .markAsPrefered: return true
        case .requestPermission: return true
        }
    }

    var debugName: String {
        switch self {
        case .selectDocument(let uuid): return "SelectDocument -> \(uuid)"
        case .markAsPrefered(let uuid): return "MarkAsPrefered -> \(uuid)"
        case .requestPermission(let uuid): return "RequestPermission -> \(uuid)"
        }
    }

}

class DocumentsCoordinator: AppCoordinator {

    let appState: AppState
    let mainCoordinator: AppCoordinator

    init(mainCoordinator: AppCoordinator, appState: AppState) {

        self.mainCoordinator = mainCoordinator
        self.appState = appState

    }

    func initialVC() -> UIViewController {

        guard let controller = DocumentsVC.instantiate(with: self, state: self.appState) else {
            AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "DocumentsVC"))
            fatalError("Unable to Load Initial ViewController")
        }

        return controller

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController) {

        if action.mustBeAsync { return }

        switch action {
        case DocumentsActions.selectDocument(let uuid): self.showDocument(uuid: uuid)
        case DocumentsActions.markAsPrefered (let uuid): self.markAsPrefered(uuid: uuid)
        case DocumentsActions.requestPermission(let uuid): self.requestPermissionForDocument(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController, with: (Bool) -> Void) {

        if action.mustBeSync { return }

        switch action {
        case DocumentsActions.selectDocument(let uuid): self.showDocument(uuid: uuid)
        case DocumentsActions.markAsPrefered (let uuid): self.markAsPrefered(uuid: uuid)
        case DocumentsActions.requestPermission(let uuid): self.requestPermissionForDocument(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    private func showDocument(uuid: String) {

    }

    private func markAsPrefered(uuid: String) {

    }

    private func requestPermissionForDocument(uuid: String) {

    }

}
