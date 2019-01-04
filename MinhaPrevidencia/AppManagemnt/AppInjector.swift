//
//  AppInjector.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
class AppInjector {

    func settings() -> SettingsManager? { return nil }
    func remoteStore() -> DataStoreManager? { return nil }
    func localStore() -> DataStoreManager? { return nil }
    func cacheStore() -> DataStoreManager? { return nil }

    //Synchronous Function to be returned with Initial Data from Settings, Cache or Stup in the caso of first execution
    func initialData() -> InitialData {

        let institutoCreation: Date = DateComponents(
            calendar: Calendar.current, timeZone: TimeZone.current,
            era: nil, year: 2000, month: 01, day: 01,
            hour: 0, minute: 0, second: 0, nanosecond: 0,
            weekday: nil, weekdayOrdinal: nil, quarter: nil,
            weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
        ).date!

        let institution = Institution(uuid: "9876567d", name: "Gurupi Prev")
        let userprofile = UserProfile(uuid: "anonymous", firstName: "Usuário", lastName: "Anônimo", username: "anonymous", birthDate: nil, genre: nil)
        let retirement = Retirement(uuid: "anonymous", startDate: institutoCreation, endDate: Date(), contributions: [], withdrawals: [])

        return InitialData(institution: institution, userInfo: userprofile, messages: [], documents: [], news: [], complaints: [], retirement: retirement)

    }

}

struct InitialData {
    let institution: Institution
    let userInfo: UserProfile
    let messages: [ComunicationMessage]
    let documents: [Document]
    let news: [NewsMessage]
    let complaints: [Complaint]
    let retirement: Retirement
}
