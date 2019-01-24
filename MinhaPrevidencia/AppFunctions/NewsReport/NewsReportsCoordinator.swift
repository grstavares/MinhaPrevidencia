//
//  NewsReportsCoordinator.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum NewsReportsActions: AppCoordinatorAction {

    case selectNewsReport(uuid: String)
    case markAsReaded(uuid: String)
    case loadOnWeb(uuid: String)

    var mustBeSync: Bool { return !self.mustBeAsync }
    var mustBeAsync: Bool {
        switch self {
        case .selectNewsReport: return false
        case .markAsReaded: return false
        case .loadOnWeb:  return false
        }
    }

    var debugName: String {
        switch self {
        case .selectNewsReport(let uuid): return "SelectNewsReport -> \(uuid)"
        case .markAsReaded(let uuid): return "MarkAsReaded -> \(uuid)"
        case .loadOnWeb(let uuid): return "LoadOnWeb -> \(uuid)"
        }
    }

}

class NewsReportsCoordinator: AppCoordinator {

    let appState: AppState
    let mainCoordinator: AppCoordinator

    init(mainCoordinator: AppCoordinator, appState: AppState) {

        self.mainCoordinator = mainCoordinator
        self.appState = appState

    }

    func initialVC() -> UIViewController {

        guard let controller = NewsReportsVC.instantiate(with: self, state: self.appState) else {
            AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "NewsReportsVC"))
            fatalError("Unable to Load Initial ViewController")
        }

        return controller

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController) {

        if action.mustBeAsync { return }

        switch action {
        case NewsReportsActions.selectNewsReport(let uuid): self.showNewsReport(uuid: uuid)
        case NewsReportsActions.markAsReaded(let uuid): self.markNewsReportAsRead(uuid: uuid)
        case NewsReportsActions.loadOnWeb(let uuid): self.showNewsReportOnWeb(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController, with: (Bool) -> Void) {

        if action.mustBeSync { return }

        switch action {
        case NewsReportsActions.selectNewsReport(let uuid): self.showNewsReport(uuid: uuid)
        case NewsReportsActions.markAsReaded(let uuid): self.markNewsReportAsRead(uuid: uuid)
        case NewsReportsActions.loadOnWeb(let uuid): self.showNewsReportOnWeb(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    private func showNewsReport(uuid: String) {

    }

    private func showNewsReportOnWeb(uuid: String) {

    }

    private func markNewsReportAsRead(uuid: String) {

    }

}
