//
//  AppInjectorTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
import SwiftSugarKit
@testable import MinhaPrevidencia

class AppInjectorTest: XCTestCase {

    override func setUp() {

        let libraryDir = FileManager.default.libraryDirectory()
        let fileUrl = libraryDir.appendingPathComponent(AppDelegate.initialDataKey)
        if FileManager.default.fileExists(atPath: fileUrl.absoluteString) {
            try? FileManager.default.removeItem(at: fileUrl)
        }

    }

    override func tearDown() { }

    func testGetMockData() {

        let sut = AppInjector()
        let initial = sut.initialData()
        XCTAssertEqual(AppDelegate.institutionId, initial.institution.uuid)

    }

    func testPersistInitialData() {

        let changedValue = "This is a new Name"

        let sut = AppInjector()
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

//        sleep(1)
//
//        let updated = sut.initialData()
//        XCTAssertEqual(AppDelegate.institutionId, updated.institution.uuid)
//        XCTAssertEqual(changedValue, updated.institution.name)

    }

}
