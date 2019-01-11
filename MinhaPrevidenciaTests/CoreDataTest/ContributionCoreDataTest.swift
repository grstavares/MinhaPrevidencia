//
//  ContributionCoreDataTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 11/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class ContributionCoreDataTest: XCTestCase {

    typealias AppModelClass = Contribution
    var entityName: String { return Contribution.entityName }
    var sut: AppModelClass { return Contribution(uuid: "uuid", source: "source", reference: Date(), value: 5.0) }

    let coredata = MockedCoreDataStack.shared

    override func setUp() {

        do {try MockedCoreDataStack.shared.clearEntity(entity: self.entityName)
        } catch { XCTFail("Unable to Clear Entity") }

    }

    override func tearDown() { }

    func testObjectSaving() throws {

        let allInstances = try coredata.getAllItems(of: self.entityName)
        XCTAssert(allInstances.count == 0)
        XCTAssert(try sut.saveInDataStore(manager: coredata.manager))

        let newQuery = try coredata.getAllItems(of: self.entityName)
        XCTAssert(newQuery.count == 1)

        let newStruct: AppModelClass? = try AppModelClass.loadFromDataStore(uuid: sut.uuid, manager: self.coredata.manager)
        XCTAssertNotNil(newStruct)
        XCTAssertEqual(newStruct?.uuid, sut.uuid)

        XCTAssert(try sut.removeFromDataStore(manager: coredata.manager))
        let anotherQuery = try coredata.getAllItems(of: self.entityName)
        XCTAssert(anotherQuery.count == 0)

    }

}
