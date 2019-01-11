//
//  CoreDataTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 11/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
@testable import MinhaPrevidencia

protocol CoreDataTest {

    associatedtype AppModelClass: CoreDataStoreItem
    var entityName: String { get }
    var sut: AppModelClass { get }

}
