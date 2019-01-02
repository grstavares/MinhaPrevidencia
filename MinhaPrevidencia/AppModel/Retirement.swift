//
//  Retirement.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct Retirement {
    
    let uuid: String;
    let startDate: Date;
    let endDate: Date;
    let contributions: [Contribution]
    let withdrawals: [Withdrawal]
    
}
