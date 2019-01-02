//
//  MainCoordinator.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit
class MainCoordinator: AppCoordinator {

    public func initialVC() -> UIViewController {
        
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "ViewController")
        return vc
        
    }

    func perform(action: AppCoordinatorAction, from vc: UIViewController) { }
    
    func perform(action: AppCoordinatorAction, from vc: UIViewController, with closure: (Bool) -> Void) -> Void {}
}
