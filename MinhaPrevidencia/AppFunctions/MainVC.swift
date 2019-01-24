//
//  MainVC.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 15/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

class MainVC: AppViewController {

    static func instantiate(with navigator: UINavigationController, coordinatedBy: AppCoordinator, injector: AppInjector) -> MainVC {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let controller = storyboard.instantiateViewController(type: MainVC.self) {
            controller.coordinator = coordinatedBy
            controller.injector = injector
            controller.navigator = navigator
            return controller
        } else { fatalError("Unable to load ViewController -> MainVC") }

    }

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewLeading: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!

    var sideMenuOpen = false
    var injector: AppInjector?
    var navigator: UINavigationController?

    override func viewDidLoad() {

        super.viewDidLoad()

        if let coordinator = self.coordinator, let injector = self.injector, let menuController = SideMenuVC.instantiate(with: coordinator, injector: injector) {
            self.addChild(menuController)
            self.menuView.addSubview(menuController.view)
            menuController.view.frame = self.menuView.frame
            menuController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            menuController.didMove(toParent: self)
        } else { fatalError("Unable to Load MenuController") }

        if let navigator = self.navigator {self.addNavigator(navigator: navigator)
        } else { fatalError("Unable to Load Navigator")}

        self.menuViewLeading.constant = -250

    }

    func toggleSideMenu() {

        self.menuViewLeading.constant = self.sideMenuOpen ? -250 : 0
        self.sideMenuOpen = !self.sideMenuOpen

    }

    func setNavigationRoot(navigator: UINavigationController) {

        if self.navigator == navigator { return }

        if let currentNavigator = self.navigator, self.children.contains(currentNavigator) {
            currentNavigator.removeFromParent()
        }

        self.addNavigator(navigator: navigator)
        self.navigator = navigator

    }

    private func addNavigator(navigator: UINavigationController) {
        self.addChild(navigator)
        self.contentView.addSubview(navigator.view)
        navigator.view.frame = self.contentView.frame
        navigator.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        navigator.didMove(toParent: self)
    }

    private func removeNavigator(navigator: UINavigationController) { navigator.removeFromParent() }

    override func performAppAction(action: AppCoordinatorAction) {

        switch action {
        case AppNavigation.toggleMenu: self.toggleSideMenu()
        default: self.coordinator?.perform(action: action, from: self)
        }

    }

}
