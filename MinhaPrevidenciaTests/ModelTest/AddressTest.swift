//
//  AddressTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
@testable import MinhaPrevidencia

class AddressTest: XCTestCase {

    let mockCountry = "BR"
    let mockRegion = "DF"
    let mockCity = "Brasília"
    let mockPostal = "70.000-000"
    let mockStreet = "Esplanada dos Ministérios"
    let mockNumber = "1"
    let mockBuild = "Congresso Nacional"
    let mockUnity = "Anexo 1"
    let mockLat = -15.799505
    let mockLong = -47.864646
    let mockIsMain = true

    override func setUp() { }

    override func tearDown() { }

    func testObjectCreationFromRaw() {

        let rawObject = self.getRawObject()
        let object = Address(from: rawObject)
        guard let notnil = object else {XCTFail("Object not Parsed"); return}

        XCTAssertEqual(object?.country, self.mockCountry, "UUID not Equal")
        XCTAssertEqual(object?.region, self.mockRegion, "Name not Equal")
        XCTAssertEqual(object?.city, self.mockCity, "UUID not Equal")
        XCTAssertEqual(object?.postalCode, self.mockPostal, "Name not Equal")
        XCTAssertEqual(object?.streetAddress, self.mockStreet, "UUID not Equal")
        XCTAssertEqual(object?.streetNumber, self.mockNumber, "Name not Equal")
        XCTAssertEqual(object?.buildName, self.mockBuild, "UUID not Equal")
        XCTAssertEqual(object?.unityNumber, self.mockUnity, "Name not Equal")
        XCTAssertEqual(object?.isMain, self.mockIsMain, "Name not Equal")

        let parsedFromObject = notnil.raw()
        XCTAssertEqual(rawObject, parsedFromObject, "Parsed Raw Is Not Equal")

    }

    func testObjectCreationFromData() {

        let data = self.encodeRaw()
        let object = Address(from: data)
        XCTAssertNotNil(object, "Object not Parsed")

        XCTAssertEqual(object?.country, self.mockCountry, "UUID not Equal")
        XCTAssertEqual(object?.region, self.mockRegion, "Name not Equal")
        XCTAssertEqual(object?.city, self.mockCity, "UUID not Equal")
        XCTAssertEqual(object?.postalCode, self.mockPostal, "Name not Equal")
        XCTAssertEqual(object?.streetAddress, self.mockStreet, "UUID not Equal")
        XCTAssertEqual(object?.streetNumber, self.mockNumber, "Name not Equal")
        XCTAssertEqual(object?.buildName, self.mockBuild, "UUID not Equal")
        XCTAssertEqual(object?.unityNumber, self.mockUnity, "Name not Equal")
        XCTAssertEqual(object?.isMain, self.mockIsMain, "Name not Equal")

    }

    func testObjectCreationFromDataWithFailure() {

        let data = CommunicationMessageTest().encodeRaw()
        let object = Address(from: data)
        XCTAssertNil(object, "Wrong Data parsed in Object")

    }

    func testObjectParsingPerformance() {

        self.measure {
            let rawObject = self.getRawObject()
            _ = Address(from: rawObject)
        }
    }

    func getRawObject() -> RawAddress {

        return RawAddress(
            country: self.mockCountry, region: self.mockRegion, city: self.mockCity,
            postalCode: self.mockPostal,
            streetAddress: self.mockStreet, streetNumber: self.mockNumber,
            buildName: self.mockBuild, unityNumber: self.mockUnity,
            latitude: self.mockLat, longitude: self.mockLong,
            isMain: self.mockIsMain
        )

    }

    func encodeRaw() -> Data {

        let object = self.getRawObject()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {return data
        } else {fatalError("Test Object can not be encoded")}

    }

}
