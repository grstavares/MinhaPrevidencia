//
//  AppInjectorTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
import CoreData
import RxSwift
import RxCocoa
import SwiftSugarKit
@testable import MinhaPrevidencia

class AppInjectorTest: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func testGetMockData() {

        let sut = AppInjector()
        let initial = sut.initialData()
        XCTAssertEqual(AppDelegate.institutionId, initial.institution.uuid)

    }

    func testPersistInitialData() {

        let changedValue = "This is a new Name"

        let sut = AppInjectorMocked()
        let initial = sut.initialData()

        let updatedInstitution = Institution(uuid: initial.institution.uuid, name: changedValue)
        let newData = InitialData(
            institution: updatedInstitution,
            userInfo: initial.userInfo,
            messages: initial.messages,
            documents: initial.documents,
            news: initial.news,
            complaints: initial.complaints,
            retirement: initial.retirement
        )

        XCTAssert(sut.persistInitialData(data: newData), "Data not Persisted!")

        let updated = sut.initialData()
        XCTAssertEqual(AppDelegate.institutionId, updated.institution.uuid)
        XCTAssertEqual(changedValue, updated.institution.name)

    }

}

class AppInjectorMock: AppInjector {

    let session: URLSession

    init(session: URLSession) {
        self.session = session
        super.init()
    }

    override func settings() -> SettingsManager? { return SettingsMock() }
    override func appRouter() -> NetworkManager? { return AppRouter(session: self.session) }
    override func authManager() -> AuthenticationManager? { return AuthManagerMock() }

}

class SettingsMock: SettingsManager {
    var institutionId: String { return AppDelegate.institutionId }
    var poolingInterval: TimeInterval { return TimeInterval(1) }
    var networkTimeOut: TimeInterval { return TimeInterval(3) }
}

class AuthManagerMock: AuthenticationManager {

    var session: BehaviorSubject<UserSession> = BehaviorSubject(value: UserSession(uuid: UserProfileEndpointTest.uuidAOnDb, token: "nulttoken"))
    var isLogged: BehaviorRelay<Bool> = BehaviorRelay(value: true)

    func currentUser() -> UserProfile? { return UserProfileEndpointTest.objectA }

    func signIn(username: String, password: String) { }

    func signUp(userProfile: UserProfile, password: String) { }

    func signOut() { }

}

class AppInjectorMocked: AppInjector {

    override func localStore() -> CoreDataManager? { return CoreDataManager(context: self.coreDataInMemory()) }

    private func coreDataInMemory() -> NSManagedObjectContext {

        guard let modelURL = Bundle.main.url(forResource: "MinhaPrevidencia", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }

        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc

        do {
            try psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            return managedObjectContext
        } catch { fatalError("Error migrating store: \(error)") }

    }

}
