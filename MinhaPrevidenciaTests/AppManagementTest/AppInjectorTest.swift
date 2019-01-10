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

    func testGetMockedInitialData() throws {

        let coredata = MockedCoreDataStack()
        try self.clearEntity(entity: Institution.entityName, context: coredata.context)

        let sut = MockedInjector(session: MockedURLSession.defaultMockedSession, dataStoreManager: coredata.manager)

        let initial = sut.initialData()
        XCTAssertEqual(AppDelegate.institutionId, initial.institution.uuid)
        XCTAssertEqual("Gurupi Prev", initial.institution.name)

    }

    func testGetInitialDataFromCoreData() throws {

        let coredata = MockedCoreDataStack()
        try self.clearEntity(entity: Institution.entityName, context: coredata.context)
        try self.saveTestDataInCoreData(manager: coredata.manager)

        let sut = MockedInjector(session: MockedURLSession.defaultMockedSession, dataStoreManager: coredata.manager)
        let initial = sut.initialData()

        guard let settings = sut.settings() else { XCTFail("Settings Manager Not Initialized!"); return }

        XCTAssertEqual(settings.institutionId, initial.institution.uuid)
        XCTAssertEqual(InstitutionEndpointTest.objectA.name, initial.institution.name)

    }

    func testPersistInitialData() {

        let changedValue = "This is a new Name"

        let coredata = MockedCoreDataStack()
        let sut = MockedInjector(session: MockedURLSession.defaultMockedSession, dataStoreManager: coredata.manager)
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

    private func saveTestDataInCoreData(manager: DataStoreManager) throws {

        _ = try InstitutionEndpointTest.objectA.saveInDataStore(manager: manager)
        _ = try InstitutionEndpointTest.objectB.saveInDataStore(manager: manager)
        manager.sync()

    }

    private func clearEntity(entity: String, context: NSManagedObjectContext) throws {

        let request = NSFetchRequest<NSManagedObject>(entityName: entity)
        let results = try context.fetch(request)
        for item in results { context.delete(item)}
        try context.save()

    }

}
