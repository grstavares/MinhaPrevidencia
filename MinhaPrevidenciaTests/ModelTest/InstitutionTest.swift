//
//  InstitutionTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class InstitutionTest: XCTestCase {

    let mockUuid = "MockUUID"
    let mockName = "MockName"

    override func setUp() { }

    override func tearDown() { }

    func testObjectCreationFromRaw() {

        let rawObject = self.getRawObject()
        let object = Institution(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.uuid, self.mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.name, self.mockName, "Name not Equal")

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectCreationFromData() {

        let data = self.encodeRaw()
        let object = Institution(from: data)
       XCTAssertNotNil(object, "Object not Parsed")

        XCTAssertEqual(object?.uuid, self.mockUuid, "UUID not Equal")
        XCTAssertEqual(object?.name, self.mockName, "Name not Equal")

    }

    func testObjectCreationFromDataWithFailure() {

        let data = CommunicationMessageTest().encodeRaw()
        let object = Institution(from: data)
        XCTAssertNil(object, "Wrong Data parsed in Object")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = Institution(from: rawObject)
        }
    }

    private func getRawObject() -> RawInstitution {

        return RawInstitution(uuid: self.mockUuid, name: self.mockName)

    }

    func encodeRaw() -> Data {

        let object = self.getRawObject()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {return data
        } else {fatalError("Test Object can not be encoded")}

    }

}
