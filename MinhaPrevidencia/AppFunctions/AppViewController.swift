//
//  AppViewController.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 14/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {

    var coordinator: AppCoordinator?
    var state: AppState?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func performAppAction(action: AppCoordinatorAction) { self.coordinator?.perform(action: action, from: self) }

    func performAppAction(action: AppCoordinatorAction, completion: (Bool) -> Void) { self.coordinator?.perform(action: action, from: self, with: completion)}

    func addMenuButton() {

        let menuImage = UIImage(named: "iconMenu")
        let menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(self.menuButtonTapped(sender:)))
        self.navigationItem.leftBarButtonItem = menuButton

    }

    @objc func menuButtonTapped(sender: Any) { self.coordinator?.perform(action: AppNavigation.toggleMenu, from: self) }

}
