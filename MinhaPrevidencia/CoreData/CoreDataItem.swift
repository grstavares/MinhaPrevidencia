//
//  CoreDataItem.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 09/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataItem {

    associatedtype CoreDataModelClass: NSManagedObject

    static func load<T>(uuid: String, manager: CoreDataManager) throws -> T?
    init?(fromCoreData object: NSManagedObject)
    func fetchRequest() -> NSFetchRequest<CoreDataModelClass>
    func coredataObject(in context: NSManagedObjectContext) -> CoreDataModelClass

}
