//
//  Coordinator.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

protocol AppCoordinatorAction {

    var mustBeAsync: Bool { get }
    var mustBeSync: Bool { get }
    var debugName: String { get }

}

protocol AppCoordinator {

    func initialVC() -> UIViewController
    func perform(action: AppCoordinatorAction, from: UIViewController)
    func perform(action: AppCoordinatorAction, from: UIViewController, with: (Bool) -> Void)

}
