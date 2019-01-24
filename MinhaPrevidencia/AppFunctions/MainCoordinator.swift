//
//  MainCoordinator.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
class MainCoordinator: AppCoordinator {

    let injector: AppInjector
    let appState: AppState

    init(injector: AppInjector, appState: AppState) {
        self.injector = injector
        self.appState = appState
    }

    public func initialVC() -> UIViewController { return RootNavigators.newsReport.viewController(mainCoordinator: self, state: self.appState)  }

    func perform(action: AppCoordinatorAction, from viewController: UIViewController) { }

    func perform(action: AppCoordinatorAction, from viewController: UIViewController, with closure: (Bool) -> Void) {}

    enum RootNavigators {

        case activities
        case newsReport

        func viewController(mainCoordinator: AppCoordinator, state: AppState) -> UIViewController {

            switch self {
            case .activities:

                guard let viewController = NewsReportsNavigationVC.instantiate(with: mainCoordinator, state: state) else {
                    AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "NewsReportsNavigationVC"))
                    fatalError("Unable to Load Initial ViewController")
                }

                return viewController

            case .newsReport:

                guard let viewController = NewsReportsNavigationVC.instantiate(with: mainCoordinator, state: state) else {
                    AppDelegate.handleError(error: AppDelegate.OperationErrors.canNotLoadViewController(name: "NewsReportsNavigationVC"))
                    fatalError("Unable to Load Initial ViewController")
                }

                return viewController

            }

        }

    }

}
