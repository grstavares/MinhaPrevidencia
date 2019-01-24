//
//  MainCoordinator.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

enum AppNavigation: AppCoordinatorAction {

    case navigateTo(MainCoordinator.ChildCoordinator)
    case toggleMenu

    var mustBeSync: Bool { return true }
    var mustBeAsync: Bool { return false }
    var debugName: String {
        switch self {
        case .navigateTo(let child): return "NavigateTo -> \(child.navigatorTitle)"
        case .toggleMenu: return "ToggleMenu"
        }
    }
}

class MainCoordinator: AppCoordinator {

    let injector: AppInjector
    let appState: AppState

    var mainVC: MainVC?

    var childCoordinators: [String: AppCoordinator] = [:]

    init(injector: AppInjector, appState: AppState) {
        self.injector = injector
        self.appState = appState
    }

    public func initialVC() -> UIViewController {

        let childType = ChildCoordinator.newsReport

        let initialCoordinator = childType.appCoordinator(main: self, state: self.appState)
        let initialVC = initialCoordinator.initialVC()
        let navigator = self.configureNavigator(for: childType, withRoot: initialVC)
        let mainVC = MainVC.instantiate(with: navigator, coordinatedBy: self, injector: self.injector)
        self.mainVC = mainVC
        return mainVC

    }

    func perform(action: AppCoordinatorAction, from requester: UIViewController) {

        if action.mustBeAsync { return }

        switch action {
        case AppNavigation.toggleMenu: self.mainVC?.performAppAction(action: action)
        case AppNavigation.navigateTo(let child):

            let coordinator = self.childCoordinators[child.coordinatorKey] ?? child.appCoordinator(main: self, state: self.appState)
            self.childCoordinators[child.coordinatorKey] = coordinator

            let controller = coordinator.initialVC()
            let navigator = self.configureNavigator(for: child, withRoot: controller)
            self.mainVC?.setNavigationRoot(navigator: navigator)

        default:

            AppDelegate.handleError(error: Error.unableToPerformAction(action.debugName))

        }

    }

    func perform(action: AppCoordinatorAction, from viewController: UIViewController, with closure: (Bool) -> Void) { }

    private func configureNavigator(for type: ChildCoordinator, withRoot root: UIViewController) -> NavigatorVC {

        root.title = type.navigatorTitle

        let navigator = NavigatorVC.init(rootViewController: root)
        navigator.title = type.navigatorTitle
        navigator.navigationBar.barStyle = .default
        navigator.navigationBar.prefersLargeTitles = true

        return navigator

    }

    private func childCoordinator(type: ChildCoordinator) -> AppCoordinator {

        if let alreadyInstantiated = self.childCoordinators[type.coordinatorKey] { return alreadyInstantiated } else {

            let coordinator = type.appCoordinator(main: self, state: self.appState)
            self.childCoordinators[type.coordinatorKey] = coordinator
            return coordinator

        }

    }

//    @objc func toggleMenu(sender: Any) { self.mainVC?.performAppAction(action: AppNavigation.toggleMenu) }

    enum ChildCoordinator: String {

        case activities
        case documents
        case financialResults
        case messages
        case newsReport
        case retirement
        case complaints
        case userProfile

        var coordinatorKey: String { return self.rawValue }

        var navigatorTitle: String {

            switch self {
            case .activities: return "Atividades"
            case .documents: return "Documentos"
            case .financialResults: return "Resultados"
            case .messages: return "Mensagens"
            case .newsReport: return "Notícias"
            case .retirement: return "Aposentadoria"
            case .complaints: return "Ouvidoria"
            case .userProfile: return "Perfil de Usuário"
            }

        }

        func appCoordinator(main: AppCoordinator, state: AppState) -> AppCoordinator {

            switch self {
            case .activities: return ActivitiesCoordinator(mainCoordinator: main, appState: state)
            case .documents: return DocumentsCoordinator(mainCoordinator: main, appState: state)
            case .financialResults: return FinancialsResultsCoordinator(mainCoordinator: main, appState: state)
            case .messages: return MessagesCoordinator(mainCoordinator: main, appState: state)
            case .newsReport: return NewsReportsCoordinator(mainCoordinator: main, appState: state)
            case .retirement: return RetirementCoordinator(mainCoordinator: main, appState: state)
            case .complaints: return ComplaintsCoordinator(mainCoordinator: main, appState: state)
            case .userProfile: return UserProfileCoordinator(mainCoordinator: main, appState: state)
            }

        }

    }

    enum Error: AppError {

        case unableToPerformAction(String)

        var code: String {
            switch self {
            case .unableToPerformAction: return "UnableToPerformAction"
            }
        }

        var details: String? {
            switch self {
            case .unableToPerformAction(let actionName): return "UnableToPerformAction -> \(actionName)"
            }
        }

    }

}
