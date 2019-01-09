//
//  StoreManager.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import RxSwift
import SwiftSugarKit

protocol DataStoreManager {

    func loadById<T: DataStoreItem>(uuid: String) -> Observable<T?>
    func create<T: DataStoreItem>(_ object: T) -> Observable<T?>
    func save<T: DataStoreItem>(_ object: T) -> Observable<Bool>
    func remove<T: DataStoreItem>(_ object: T) -> Observable<Bool>
    func search<T: DataStoreItem>(predicate: NSPredicate) -> Observable<[T]>
    func sync()

}

protocol DataStoreItem {

    static func loadFromDataStore<T: DataStoreItem>(uuid: String, manager: CoreDataManager) throws -> T?
    func saveInDataStore(manager: CoreDataManager) throws -> Bool
    func removeFromDataStore(manager: CoreDataManager) throws -> Bool

}

enum DataStoreError: AppError {

    case unableToLoadContainer(type: String, reason: String)
    case unableToLoadFromContainer(type: String, reason: String)
    case unableToSaveInContainer(type: String, reason: String)
    case unableToParseObject(type: String, reason: String)
    case invalidManager(expected: String, actual: String)

    var code: String {
        switch self {
        case .unableToLoadContainer(let type, let reason): return "UnableToLoadContainer of type \(type): \(reason)"
        case .unableToLoadFromContainer(let type, let reason): return "UnableToLoadFromContainer of type \(type): \(reason)"
        case .unableToSaveInContainer(let type, let reason): return "UnableToLoadContainer of type \(type): \(reason)"
        case .unableToParseObject(let type, let reason): return "UnableToParseObject of type \(type): \(reason)"
        case .invalidManager(let expected, let actual): return "InvalidPersistenceManager of type \(expected): \(actual)"
        }
    }

}
