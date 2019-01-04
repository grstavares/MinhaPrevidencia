//
//  AppState.swift
//  AppReference
//
//  Created by Gustavo Tavares on 02/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import Foundation
import RxSwift

class AppState: StateManager {

    let institution: BehaviorSubject<Institution>
    let userInfo: BehaviorSubject<UserProfile>
    let messages: BehaviorSubject<[ComunicationMessage]>
    let documents: BehaviorSubject<[Document]>
    let news: BehaviorSubject<[NewsMessage]>
    let complaints: BehaviorSubject<[Complaint]>
    let retirement: BehaviorSubject<Retirement>

    init(injector: AppInjector, data: InitialData) {
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

}
