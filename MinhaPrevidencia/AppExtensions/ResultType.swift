//
//  ResultType.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 07/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
public enum Result<Value, Error: Swift.Error> where Value: Equatable {
    case value(Value), error(Error)
}
