//
//  Data+JsonConvertible.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 08/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
extension Data {

    func parseObject<T: JsonConvertible>(ofType: T.Type) -> T? { return T(from: self) }

}
