//
//  NewsMessage.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
struct NewsMessage {
    
    let uuid: String;
    let title: String;
    let contents: String;
    let dateCreation: Date;
    let lastUpdate: Date?;
    let url: URL?;
    
}
