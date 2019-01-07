//
//  AppState.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import SwiftSugarKit
import RxSwift

class AppState: StateManager {

    let injector: AppInjector

    let institution: BehaviorSubject<Institution>
    let userInfo: BehaviorSubject<UserProfile>
    let messages: BehaviorSubject<[CommunicationMessage]>
    let documents: BehaviorSubject<[Document]>
    let news: BehaviorSubject<[NewsReport]>
    let complaints: BehaviorSubject<[Complaint]>
    let retirement: BehaviorSubject<Retirement>

    var areObservablesActive: Bool = false

    init(injector: AppInjector, data: InitialData) {

        self.injector = injector

        self.institution = BehaviorSubject(value: data.institution)
        self.userInfo = BehaviorSubject(value: data.userInfo)
        self.messages = BehaviorSubject(value: data.messages)
        self.documents = BehaviorSubject(value: data.documents)
        self.news = BehaviorSubject(value: data.news)
        self.complaints = BehaviorSubject(value: data.complaints)
        self.retirement = BehaviorSubject(value: data.retirement)

    }

    public func refresh() {
        self.refreshInstitution()
        self.refreshUserInfo()
        self.refreshMessages()
        self.refreshDocuments()
        self.refreshNews()
        self.refreshComplaints()
        self.refreshRetirement()
    }

    public func refreshInstitution() {}
    public func refreshUserInfo() {}
    public func refreshMessages() {}
    public func refreshDocuments() {}
    public func refreshNews() {}
    public func refreshComplaints() {}
    public func refreshRetirement() {}

    public func startObservables() {

        guard areObservablesActive == false else { return }

        // Start Observables using WebSockets or HTTP Pooling

        self.areObservablesActive = true

    }

    public func pauseObservables() {

        self.areObservablesActive = false

    }

    public func persistInLocalStorage() {

        do {

            let instutionData = try self.institution.value()
            let userInfoData = try self.userInfo.value()
            let messagesData = try self.messages.value()
            let documentsData = try self.documents.value()
            let newsData = try self.news.value()
            let complaintsData = try self.complaints.value()
            let retirementData = try self.retirement.value()

            let toBePersisted = InitialData(
                institution: instutionData,
                userInfo: userInfoData,
                messages: messagesData,
                documents: documentsData,
                news: newsData,
                complaints: complaintsData,
                retirement: retirementData
            )

            _ = injector.persistInitialData(data: toBePersisted)

        } catch { AppErrorControl.registerAppError(error: AppDelegate.OperationErrors.canNotPersistFileOnDisk, file: #file, line: #line) }

    }

}
