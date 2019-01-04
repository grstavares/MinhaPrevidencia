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

    public func initialVC() -> UIViewController {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        return viewController

    }

    func perform(action: AppCoordinatorAction, from viewController: UIViewController) { }

    func perform(action: AppCoordinatorAction, from viewController: UIViewController, with closure: (Bool) -> Void) {}

}
