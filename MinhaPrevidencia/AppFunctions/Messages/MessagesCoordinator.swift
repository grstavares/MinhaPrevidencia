//
//  MessagesCoordinator.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum MessagesAction: AppCoordinatorAction {

    case selectMessage(uuid: String)
    case markAsReaded(uuid: String)
    case createMessage(message: CommunicationMessage, sendIt: Bool)
    case sendMessage(uuid: String)
    case archiveMessage(uuid: String)
    case removeMessage(uuid: String)

    var mustBeSync: Bool { return !self.mustBeAsync }
    var mustBeAsync: Bool {

        switch self {
        case .selectMessage: return false
        case .markAsReaded: return true
        case .createMessage: return true
        case .sendMessage: return true
        case .archiveMessage: return true
        case .removeMessage: return true
        }

    }

    var debugName: String {
        switch self {
        case .selectMessage(let uuid): return "SelectMessage -> \(uuid)"
        case .markAsReaded(let uuid): return "MarkAsReaded -> \(uuid)"
        case .createMessage(let message): return "CreateMessage -> \(message)"
        case .sendMessage(let uuid): return "SendMessage -> \(uuid)"
        case .archiveMessage(let uuid): return "ArchiveMessage -> \(uuid)"
        case .removeMessage(let uuid): return "RemoveMessage -> \(uuid)"
        }
    }

}

class MessagesCoordinator: AppCoordinator {

    let appState: AppState
    let mainCoordinator: AppCoordinator

    init(mainCoordinator: AppCoordinator, appState: AppState) {

        self.mainCoordinator = mainCoordinator
        self.appState = appState

    }

    func initialVC() -> UIViewController {

        guard let controller = MessagesVC.instantiate(with: self, state: self.appState) else {
            AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "MessagesVC"))
            fatalError("Unable to Load Initial ViewController")
        }

        return controller

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController) {

        if action.mustBeAsync { return }

        switch action {
        case MessagesAction.selectMessage: return
        case MessagesAction.markAsReaded: return
        case MessagesAction.createMessage: return
        case MessagesAction.sendMessage: return
        case MessagesAction.archiveMessage: return
        case MessagesAction.removeMessage: return
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController, with: (Bool) -> Void) {

        if action.mustBeSync { return }

        switch action {
        case MessagesAction.selectMessage: return
        case MessagesAction.markAsReaded: return
        case MessagesAction.createMessage: return
        case MessagesAction.sendMessage: return
        case MessagesAction.archiveMessage: return
        case MessagesAction.removeMessage: return
        default: mainCoordinator.perform(action: action, from: requester)}

    }

}
