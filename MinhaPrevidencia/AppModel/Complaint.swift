//
//  Complaint.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct Complaint {
    
    let uuid: String;
    let title: String;
    let content: String;
    let dateCreation: Date;
    let dateReception: Date?;
    let status: ComplaintStatus
    
}

struct ComplaintStatus {
    let code: String;
    let description: String;
}
