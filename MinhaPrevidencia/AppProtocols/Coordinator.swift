//
//  Coordinator.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

protocol AppCoordinatorAction { }

protocol AppCoordinator {
    
    func initialVC() -> UIViewController;
    func perform(action: AppCoordinatorAction, from: UIViewController) -> Void;
    func perform(action: AppCoordinatorAction, from: UIViewController, with: (Bool) -> Void) -> Void;
    
}
