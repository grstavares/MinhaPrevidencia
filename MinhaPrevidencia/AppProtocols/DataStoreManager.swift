//
//  StoreManager.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import RxSwift

protocol DataStoreManager {

    func loadById<T>(uuid: String) -> Observable<T?>
    func create<T>(_ object: T) -> Observable<T?>
    func save<T>(_ object: T) -> Observable<Bool>
    func remove<T>(_ object: T) -> Observable<Bool>
    func search<T>(predicate: NSPredicate) -> Observable<[T]>

}
