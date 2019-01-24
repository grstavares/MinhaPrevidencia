//
//  FinancialsResultsCoordinator.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum FinancialResultsAction: AppCoordinatorAction {

    case selectCategory(category: String)
    case selectFinancialEntry(uuid: String)

    var mustBeSync: Bool { return !self.mustBeAsync }

    var mustBeAsync: Bool {
        switch self {
        case .selectCategory: return false
        case .selectFinancialEntry: return false
        }
    }

    var debugName: String {
        switch self {
        case .selectCategory(let uuid): return "SelectCategory -> \(uuid)"
        case .selectFinancialEntry(let uuid): return "SelectFinancialEntry -> \(uuid)"
        }
    }

}

class FinancialsResultsCoordinator: AppCoordinator {

    let appState: AppState
    let mainCoordinator: AppCoordinator

    init(mainCoordinator: AppCoordinator, appState: AppState) {

        self.mainCoordinator = mainCoordinator
        self.appState = appState

    }

    func initialVC() -> UIViewController {

        guard let controller = FinancialResultsVC.instantiate(with: self, state: self.appState) else {
            AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "FinancialResultsVC"))
            fatalError("Unable to Load Initial ViewController")
        }

        return controller

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController) {

        if action.mustBeAsync { return }

        switch action {
        case FinancialResultsAction.selectCategory(let category): self.showCategory(category: category)
        case FinancialResultsAction.selectFinancialEntry(let uuid): self.showFinancialEntry(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController, with: (Bool) -> Void) {

        if action.mustBeSync { return }

        switch action {
        case FinancialResultsAction.selectCategory(let category): self.showCategory(category: category)
        case FinancialResultsAction.selectFinancialEntry(let uuid): self.showFinancialEntry(uuid: uuid)
        default: mainCoordinator.perform(action: action, from: requester)}

    }

    private func showCategory(category: String) {

    }

    private func showFinancialEntry(uuid: String) {

    }

}
