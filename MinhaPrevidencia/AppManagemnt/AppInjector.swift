//
//  AppInjector.swift
//  MinhaPrevidencia
//
//  Created by Gustavo Tavares on 03/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import RxSwift
import SwiftSugarKit

class AppInjector {

    private lazy var _appRouter: NetworkManager = AppRouter(session: URLSession.shared)
    private lazy var _localStore: CoreDataManager = CoreDataManager(context: AppDelegate.coreDataContext())

    private let bag = DisposeBag()

    func settings() -> SettingsManager? { return nil }
    func remoteStore() -> DataStoreManager? { return nil }
    func localStore() -> CoreDataManager? { return self._localStore }
    func cacheStore() -> DataStoreManager? { return nil }
    func authManager() -> AuthenticationManager? { return nil }
    func appRouter() -> NetworkManager? { return self._appRouter }

    //Synchronous Function to be returned with Initial Data from Settings, Cache or Stup in the caso of first execution
    func initialData() -> InitialData {

        if let initial = self.fromCoreData(using: self._localStore) { return initial
        } else { return self.mockedInitialData() }

    }

    func persistInitialData(data: InitialData) -> Bool {

        var result: Bool = false
        do {result = try data.institution.saveInDataStore(manager: self._localStore)
        } catch { AppErrorControl.registerAppError(error: DataStoreError.unableToSaveInContainer(type: "Institution", reason: error.localizedDescription)) }

        return result

    }

    private func mockedInitialData() -> InitialData {

        let institutoCreation: Date = DateComponents(
            calendar: Calendar.current, timeZone: TimeZone.current,
            era: nil, year: 2000, month: 01, day: 01,
            hour: 0, minute: 0, second: 0, nanosecond: 0,
            weekday: nil, weekdayOrdinal: nil, quarter: nil,
            weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
            ).date!

        let institution = Institution(uuid: AppDelegate.institutionId, name: "Gurupi Prev")
        let userprofile = UserProfile(uuid: "anonymous", firstName: "Usuário", lastName: "Anônimo", username: "anonymous", birthDate: nil, genre: nil)
        let retirement = Retirement(uuid: "anonymous", startDate: institutoCreation, endDate: Date(), contributions: [], withdrawals: [])

        return InitialData(institution: institution, userInfo: userprofile, messages: [], documents: [], news: [], complaints: [], retirement: retirement)

    }

    private func fromCoreData(using manager: CoreDataManager) -> InitialData? {

        do {

            let persistedInstitution: Institution? = try Institution.loadFromDataStore(uuid: AppDelegate.institutionId, manager: manager)
            let mocked = mockedInitialData()

            let initial = InitialData(
                institution: persistedInstitution ?? mocked.institution,
                userInfo: mocked.userInfo,
                messages: mocked.messages,
                documents: mocked.documents,
                news: mocked.news,
                complaints: mocked.complaints,
                retirement: mocked.retirement
            )

            return initial

        } catch {
            AppErrorControl.registerAppError(error: DataStoreError.unableToLoadContainer(type: "", reason: error.localizedDescription))
            return nil
        }

    }

}

struct InitialData {
    let institution: Institution
    let userInfo: UserProfile
    let messages: [CommunicationMessage]
    let documents: [Document]
    let news: [NewsReport]
    let complaints: [Complaint]
    let retirement: Retirement

    struct CodableData: Codable {
        let institution: RawInstitution
        let userInfo: RawUserProfile
        let messages: [RawComunicationMessage]
        let documents: [RawDocument]
        let news: [RawNewsReport]
        let complaints: [RawComplaint]
        let retirement: RawRetirement
    }

}

extension InitialData {

    init?(from data: Data) {

        let decoder = JSONDecoder()
        guard let rawValues = try? decoder.decode(CodableData.self, from: data) else { return nil }

        guard let parsedInstitution = Institution(from: rawValues.institution) else { return nil }
        guard let parsedUserInfo = UserProfile(from: rawValues.userInfo) else { return nil }
        let parsedMessages = rawValues.messages.compactMap { CommunicationMessage(from: $0) }
        let parsedDocuments = rawValues.documents.compactMap { Document(from: $0) }
        let parsedNews = rawValues.news.compactMap { NewsReport(from: $0) }
        let parsedComplaints = rawValues.complaints.compactMap { Complaint(from: $0) }
        guard let parsedRetirement = Retirement(from: rawValues.retirement) else { return nil }

        self.institution = parsedInstitution
        self.userInfo = parsedUserInfo
        self.messages = parsedMessages
        self.documents = parsedDocuments
        self.news = parsedNews
        self.complaints = parsedComplaints
        self.retirement = parsedRetirement

    }

    func data() -> Data? {

        let rawInstitution = self.institution.raw()
        let rawUserInfo = self.userInfo.raw()
        let rawMessages = self.messages.compactMap { $0.raw() }
        let rawDocuments = self.documents.compactMap { $0.raw() }
        let rawNews = self.news.compactMap { $0.raw() }
        let rawComplaints = self.complaints.compactMap { $0.raw() }
        let rawRetirement = self.retirement.raw()

        let rawdata = CodableData(
            institution: rawInstitution,
            userInfo: rawUserInfo,
            messages: rawMessages,
            documents: rawDocuments,
            news: rawNews,
            complaints: rawComplaints,
            retirement: rawRetirement
        )

        let encoder = JSONEncoder()
        return try? encoder.encode(rawdata)

    }

}
