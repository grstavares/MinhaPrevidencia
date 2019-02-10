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

    static let devUrl = "https://j4j2c48op0.execute-api.us-east-1.amazonaws.com/v111111111/"
    static let qaUrl = "https://j4j2c48op0.execute-api.us-east-1.amazonaws.com/v111111111/"
    static let stageUrl = "https://j4j2c48op0.execute-api.us-east-1.amazonaws.com/v111111111/"
    static let prodUrl = "https://j4j2c48op0.execute-api.us-east-1.amazonaws.com/v111111111/"

    static let initialDataKey = "InitialData"
    static let institutionId = "177ac1f4-a78d-407b-b002-461f2ac55950"

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

        return InitialData(institution: institution, userInfo: userprofile, messages: [], documents: [], news: [], complaints: [], financialEntries: [], retirement: retirement)

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
