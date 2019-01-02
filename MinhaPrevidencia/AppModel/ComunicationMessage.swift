//
//  Message.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct ComunicationMessage {
    
    let uuid: String;
    let title: String;
    let summary: String?;
    let contents: String;
    let dateCreation: Date;
    let userOrigin: String;
    let recipients: [String];
    
}
