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

    private lazy var _settings: SettingsManager = AppSettings()
    private lazy var _appRouter: NetworkManager = AppRouter(session: URLSession.shared)
    private lazy var _localStore: CoreDataManager = CoreDataManager(context: AppDelegate.coreDataContext())

    private let bag = DisposeBag()

    func settings() -> SettingsManager? { return nil }
    func remoteStore() -> DataStoreManager? { return nil }
    func localStore() -> DataStoreManager? { return self._localStore }
    func cacheStore() -> DataStoreManager? { return nil }
    func authManager() -> AuthenticationManager? { return nil }
    func appRouter() -> NetworkManager? { return self._appRouter }

    //Synchronous Function to be returned with Initial Data from Settings, Cache or Stup in the caso of first execution
    func initialData() -> InitialData {

        if let store = self.localStore() as? CoreDataManager, let initial = self.fromCoreData(using: store) { return initial
        } else { return AppDelegate.mockedInitialData() }

    }

    func persistInitialData(data: InitialData) -> Bool {

        guard let store = self.localStore() else { return false }
        do {

            var result = true

            if try !data.institution.saveInDataStore(manager: store) { result = false }
            if try !data.retirement.saveInDataStore(manager: store) { result = false }
            if try !data.userInfo.saveInDataStore(manager: store) { result = false }
            try data.messages.forEach { if try !$0.saveInDataStore(manager: store) { result = false } }
            try data.documents.forEach { if try !$0.saveInDataStore(manager: store) { result = false } }
            try data.news.forEach { if try !$0.saveInDataStore(manager: store) { result = false } }
            try data.complaints.forEach { if try !$0.saveInDataStore(manager: store) { result = false } }

            return result

        } catch {
            AppDelegate.handleError(error: DataStoreError.unableToSaveInContainer(type: "Institution", reason: error.localizedDescription))
            return false
        }

    }

    private func fromCoreData(using manager: CoreDataManager) -> InitialData? {

        let institutionId = _settings.institutionId
        let userInfoId = _settings.lastLoggedUserId

        let oneMontAgoDate = Date().addingTimeInterval(Constants.numberOfSecondsInMonth * -1)
        let oneMonthAgoPredicate = NSPredicate(format: "dateCreation > %@", oneMontAgoDate as NSDate)

        let twoWeeksAgoDate = Date().addingTimeInterval(Constants.numberOfSecondsInDay * 14 * -1)
        let twoWeeksAgoPredicate = NSPredicate(format: "dateCreation > %@", twoWeeksAgoDate as NSDate)

        do {

            let persistedInstitution: Institution? = try Institution.loadFromDataStore(uuid: institutionId, manager: manager)
            let persistedRetirement: Retirement? = try Retirement.loadFromDataStore(uuid: institutionId, manager: manager)
            let persistedUserInfo: UserProfile? = try UserProfile.loadFromDataStore(uuid: userInfoId, manager: manager)
            let persistedMessages: [CommunicationMessage] = try CommunicationMessage.loadCollectionFromDataStore(predicate: oneMonthAgoPredicate, manager: manager)
            let persistedNews: [NewsReport] = try NewsReport.loadCollectionFromDataStore(predicate: twoWeeksAgoPredicate, manager: manager)
            let persistedComplaints: [Complaint] = try Complaint.loadCollectionFromDataStore(predicate: nil, manager: manager)
            let persistedFinancials: [FinancialEntry] = try FinancialEntry.loadCollectionFromDataStore(predicate: nil, manager: manager)
            let persistedDocuments: [Document] = try Document.loadCollectionFromDataStore(predicate: twoWeeksAgoPredicate, manager: manager)
            let preferedDocuments: [Document] = try Document.loadCollectionFromDataStore(predicate: self.predicateForUserVisibleDocuments(userId: userInfoId), manager: manager)
            let allDocuments = Array(Set(persistedDocuments + preferedDocuments))

            let mocked = AppDelegate.mockedInitialData()

            let initial = InitialData(
                institution: persistedInstitution ?? mocked.institution,
                userInfo: persistedUserInfo ?? mocked.userInfo,
                messages: persistedMessages,
                documents: allDocuments,
                news: persistedNews,
                complaints: persistedComplaints,
                financialEntries: persistedFinancials,
                retirement: persistedRetirement ?? mocked.retirement
            )

            return initial

        } catch {
            AppDelegate.handleError(error: DataStoreError.unableToLoadContainer(type: manager.description, reason: error.localizedDescription))
            return nil
        }

    }

    private func predicateForUserVisibleDocuments(userId: String?) -> NSPredicate? {
        return nil
    }

}

struct InitialData {
    let institution: Institution
    let userInfo: UserProfile
    let messages: [CommunicationMessage]
    let documents: [Document]
    let news: [NewsReport]
    let complaints: [Complaint]
    let financialEntries: [FinancialEntry]
    let retirement: Retirement

    struct CodableData: Codable {
        let institution: RawInstitution
        let userInfo: RawUserProfile
        let messages: [RawComunicationMessage]
        let documents: [RawDocument]
        let news: [RawNewsReport]
        let complaints: [RawComplaint]
        let financialEntries: [RawFinancialEntry]
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
        let parsedFinancial = rawValues.financialEntries.compactMap { FinancialEntry(from: $0) }
        guard let parsedRetirement = Retirement(from: rawValues.retirement) else { return nil }

        self.institution = parsedInstitution
        self.userInfo = parsedUserInfo
        self.messages = parsedMessages
        self.documents = parsedDocuments
        self.news = parsedNews
        self.complaints = parsedComplaints
        self.financialEntries = parsedFinancial
        self.retirement = parsedRetirement

    }

    func data() -> Data? {

        let rawInstitution = self.institution.raw()
        let rawUserInfo = self.userInfo.raw()
        let rawMessages = self.messages.compactMap { $0.raw() }
        let rawDocuments = self.documents.compactMap { $0.raw() }
        let rawNews = self.news.compactMap { $0.raw() }
        let rawComplaints = self.complaints.compactMap { $0.raw() }
        let rawFinancials = self.financialEntries.compactMap { $0.raw() }
        let rawRetirement = self.retirement.raw()

        let rawdata = CodableData(
            institution: rawInstitution,
            userInfo: rawUserInfo,
            messages: rawMessages,
            documents: rawDocuments,
            news: rawNews,
            complaints: rawComplaints,
            financialEntries: rawFinancials,
            retirement: rawRetirement
        )

        let encoder = JSONEncoder()
        return try? encoder.encode(rawdata)

    }

}
