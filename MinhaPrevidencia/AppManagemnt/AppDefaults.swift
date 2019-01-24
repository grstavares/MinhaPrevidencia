//
//  AppDefaults.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 04/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import SwiftSugarKit

extension AppDelegate {

    static let devUrl = "https://dev.endpoint.com"
    static let qaUrl = "https://qa.endpoint.com"
    static let stageUrl = "https://stage.endpoint.com"
    static let prodUrl = "https://prod.endpoint.com"

    static let initialDataKey = "InitialData"
    static let institutionId = "9876567d"

    static func mockedInitialData() -> InitialData {

        let institutoCreation: Date = DateComponents(
            calendar: Calendar.current, timeZone: TimeZone.current,
            era: nil, year: 2000, month: 01, day: 01,
            hour: 0, minute: 0, second: 0, nanosecond: 0,
            weekday: nil, weekdayOrdinal: nil, quarter: nil,
            weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
            ).date!

        let institution = Institution(uuid: AppDelegate.institutionId, name: "Gurupi Prev")
        let userprofile = UserProfile(uuid: "anonymous", firstName: "Usuário", lastName: "Anônimo", username: "anonymous", phoneNumber: nil, birthDate: nil, genre: nil)
        let retirement = Retirement(uuid: "anonymous", startDate: institutoCreation, endDate: Date(), contributions: [], withdrawals: [])

        let rawNews1 = RawNewsReport.init(uuid: "asdasd", title: "Novo Convênio", contents: "Este é o conteúdo da notícia", dateCreation: Date().timeIntervalSince1970, lastUpdate: nil, url: nil, imageUrl: nil, wasDeleted: false)
        let rawNews2 = RawNewsReport.init(uuid: "fdsfds", title: "Ganhamos o Bolão", contents: "Este é o conteúdo da notícia", dateCreation: Date().timeIntervalSince1970, lastUpdate: nil, url: nil, imageUrl: nil, wasDeleted: false)

        let news: [NewsReport] = [NewsReport(from: rawNews1)!, NewsReport(from: rawNews2)! ]

        return InitialData(institution: institution, userInfo: userprofile, messages: [], documents: [], news: news, complaints: [], financialEntries: [], retirement: retirement)

    }

}

extension RemoteEndpoint {

    var environment: RemoteEnvironment {

        #if DEBUG
        return RemoteEnvironment.development
        #elseif QA
        return RemoteEnvironment.quality
        #elseif STAGE
        return RemoteEnvironment.staging
        #else
        return RemoteEnvironment.production
        #endif

    }

    var baseURL: URL {

        var stringUrl: String
        switch self.environment {
        case .development: stringUrl = AppDelegate.devUrl
        case .quality: stringUrl = AppDelegate.qaUrl
        case .staging: stringUrl = AppDelegate.stageUrl
        case .production: stringUrl = AppDelegate.prodUrl
        }

        if let url = URL(string: stringUrl) {return url
        } else { fatalError("RemoteEndpoint Not Configured! \(#file), \(#line)") }

    }

}
