//
//  AppDelegate.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appInjector: AppInjector?
    var appState: AppState?
    var mainCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let injector = AppInjector()
        let initial = injector.initialData()
        let state = AppState(injector: injector, data: initial)
        let coordinator = MainCoordinator(injector: injector, appState: state)

        self.appInjector = injector
        self.appState = state
        self.mainCoordinator = coordinator

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.mainCoordinator.initialVC()
        self.window?.makeKeyAndVisible()

        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {

        self.appState?.persistInLocalStorage()
        self.appState?.pauseObservables()

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

        self.appState?.startObservables()

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
