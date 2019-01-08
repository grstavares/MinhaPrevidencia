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

// swiftlint:disable type_body_length file_length
class AppState: StateManager {

    enum AppStateError: AppError, Equatable {

        case apiError(apiName: String)
        case nullHttpResponse
        case nullHttpResponseBody
        case invalidHttpRequest(apiName: String)
        case invalidHttpResponse(expected: String, received: String)
        case invalidObjectData(type: String, data: Data)
        case networkError(error: HTTPError)
        case routerUnavailable

        var code: String {
            switch self {
            case .apiError (let name): return "APIError:" + name
            case .nullHttpResponse: return "NullHttpResponse"
            case .nullHttpResponseBody: return "NullHttpResponseBody"
            case .invalidHttpRequest(let apiName): return "InvalidHttpRequest" + apiName
            case .invalidHttpResponse(let expected, let received): return "InvalidHttpResponse(expected: \(expected), received: \(received)"
            case .invalidObjectData(let type, let data): return "InvalidObjectData(forType: \(type), received: \(String(data: data, encoding: .utf8) ?? "NullValue")"
            case .networkError(let error): return "NetworkError -> \(error.localizedDescription)"
            case .routerUnavailable: return "RouterUnavailable"
            }
        }
    }

    let bag: DisposeBag = DisposeBag()
    var taskBag: [String: (Date, URLSessionTask?)] = [:]

    let injector: AppInjector
    let router: NetworkManager?
    let circuitBreakLimit: TimeInterval = 3 * 60
    let poolingInterval: TimeInterval = 6 * 50
    var poolingTimer: Timer?

    var userSession: UserSession? = nil {
        didSet { if oldValue != userSession { self.refresh(tokenChanged: true) } }
    }

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
        self.router = injector.appRouter()

        self.institution = BehaviorSubject(value: data.institution)
        self.userInfo = BehaviorSubject(value: data.userInfo)
        self.messages = BehaviorSubject(value: data.messages)
        self.documents = BehaviorSubject(value: data.documents)
        self.news = BehaviorSubject(value: data.news)
        self.complaints = BehaviorSubject(value: data.complaints)
        self.retirement = BehaviorSubject(value: data.retirement)

        if let authService = injector.authManager() {

            authService.session.subscribe(onNext: { session in
                self.userSession = session
            }).disposed(by: self.bag)

        }

        self.refresh()

    }

    public func refresh(tokenChanged: Bool = false) {
        self.refreshInstitution(tokenChanged: tokenChanged)
        self.refreshUserInfo(tokenChanged: tokenChanged)
        self.refreshMessages(tokenChanged: tokenChanged)
        self.refreshDocuments(tokenChanged: tokenChanged)
        self.refreshNews(tokenChanged: tokenChanged)
        self.refreshComplaints(tokenChanged: tokenChanged)
        self.refreshRetirement(tokenChanged: tokenChanged)
    }

    public func refreshInstitution(tokenChanged: Bool) {

        let taskKey = AppState.keyInstitution
        guard self.mustCallURLSessionTask(for: taskKey, tokenChanged: tokenChanged) else { return }

        guard let uuid = try? self.institution.value().uuid else { return }

        let api = InstitutionApi.get(uuid: uuid, authToken: self.userSession?.token)
        let task = self.refreshObject(api: api, objectType: Institution.self) { (result) in

            switch result {
            case .value(let value): self.institution.onNext(value)
            case .error(let appError): AppErrorControl.registerAppError(error: appError)
            }

        }

        self.taskBag[taskKey] = (Date(), task)

    }

    public func refreshUserInfo(tokenChanged: Bool) {

        let taskKey = AppState.keyUserInfo
        guard self.mustCallURLSessionTask(for: taskKey, tokenChanged: tokenChanged) else { return }

        guard let uuid = self.userSession?.uuid else { return }

        let api = UserProfileApi.get(uuid: uuid, authToken: self.userSession?.token)
        let task = self.refreshObject(api: api, objectType: UserProfile.self) { (result) in

            switch result {
            case .value(let value): self.userInfo.onNext(value)
            case .error(let appError): AppErrorControl.registerAppError(error: appError)
            }

        }

        self.taskBag[taskKey] = (Date(), task)

    }

    public func refreshMessages(tokenChanged: Bool) {

        let taskKey = AppState.keyMessages
        guard self.mustCallURLSessionTask(for: taskKey, tokenChanged: tokenChanged) else { return }

        let api = CommunicationMessageApi.getAll(authToken: self.userSession?.token)
        let task = self.refreshCollection(api: api, objectType: CommunicationMessage.self, rawType: RawComunicationMessage.self) { (result) in

            switch result {
            case .value(let value): self.messages.onNext(value)
            case .error(let appError): AppErrorControl.registerAppError(error: appError)
            }

        }

        self.taskBag[taskKey] = (Date(), task)

    }

    public func refreshDocuments(tokenChanged: Bool) {

        let taskKey = AppState.keyDocuments
        guard self.mustCallURLSessionTask(for: taskKey, tokenChanged: tokenChanged) else { return }

        let api = DocumentApi.getAll(authToken: self.userSession?.token)
        let task = self.refreshCollection(api: api, objectType: Document.self, rawType: RawDocument.self) { (result) in

            switch result {
            case .value(let value): self.documents.onNext(value)
            case .error(let appError): AppErrorControl.registerAppError(error: appError)
            }

        }

        self.taskBag[taskKey] = (Date(), task)

    }

    public func refreshNews(tokenChanged: Bool) {

        let taskKey = AppState.keyNews
        guard self.mustCallURLSessionTask(for: taskKey, tokenChanged: tokenChanged) else { return }

        let api = NewsReportApi.getAll(authToken: self.userSession?.token)
        let task = self.refreshCollection(api: api, objectType: NewsReport.self, rawType: RawNewsReport.self) { (result) in

            switch result {
            case .value(let value): self.news.onNext(value)
            case .error(let appError): AppErrorControl.registerAppError(error: appError)
            }

        }

        self.taskBag[taskKey] = (Date(), task)

    }

    public func refreshComplaints(tokenChanged: Bool) {

        let taskKey = AppState.keyComplaints
        guard self.mustCallURLSessionTask(for: taskKey, tokenChanged: tokenChanged) else { return }

        let api = ComplaintApi.getAll(authToken: self.userSession?.token)
        let task = self.refreshCollection(api: api, objectType: Complaint.self, rawType: RawComplaint.self) { (result) in

            switch result {
            case .value(let value): self.complaints.onNext(value)
            case .error(let appError): AppErrorControl.registerAppError(error: appError)
            }

        }

        self.taskBag[taskKey] = (Date(), task)

    }

    public func refreshRetirement(tokenChanged: Bool) {

        let taskKey = AppState.keyRetirement
        guard self.mustCallURLSessionTask(for: taskKey, tokenChanged: tokenChanged) else { return }

        guard let uuid = self.userSession?.uuid else { return }

        if let runningTask = self.taskBag[taskKey] {

            if tokenChanged { runningTask.1?.cancel()
            } else {

                if self.taskExecutionTimeIsUnderCircuitBreakLimit(taskStart: runningTask.0) { runningTask.1?.cancel()
                } else { return }

            }

        }

        let api = RetirementApi.getByUser(uuid: uuid, authToken: self.userSession?.token)
        let task = self.refreshObject(api: api, objectType: Retirement.self) { (result) in

            switch result {
            case .value(let value): self.retirement.onNext(value)
            case .error(let appError): AppErrorControl.registerAppError(error: appError)
            }

        }

        self.taskBag[taskKey] = (Date(), task)

    }

    public func startObservables() {

        guard areObservablesActive == false else { return }
        self.poolingTimer = Timer(timeInterval: self.poolingInterval, repeats: true, block: { _ in self.refresh() })
        self.areObservablesActive = true

    }

    public func pauseObservables() {

        self.poolingTimer?.invalidate()
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

    private func refreshObject<T: JsonConvertible>(api: RemoteEndpoint, objectType: T.Type, result: @escaping (Result<T, AppStateError>) -> Void) -> URLSessionTask? {

        guard let router = self.router else { result(Result.error(AppStateError.routerUnavailable)); return nil }
        var task: URLSessionTask?

        do {

            task = try router.request(api) { (data, response, error) in

                let httpResult = self.parseResponse(data: data, response: response, error: error)
                switch httpResult {
                case .value:

                    //API for GetAll must return Data
                    guard let notnil = data else {
                        result(Result.error(AppStateError.nullHttpResponseBody))
                        return
                    }

                    if let parsed = T(from: notnil) {result(Result.value(parsed))
                    } else { result(Result.error(AppStateError.invalidObjectData(type: String(describing: T.self), data: notnil))) }

                case .error(let appError): result(Result.error(appError))

                }

            }

        } catch { result(Result.error(AppStateError.invalidHttpRequest(apiName: String(describing: api)))) }

        return task

    }

    private func refreshCollection<T: JsonConvertible, U: Codable>(api: RemoteEndpoint, objectType: T.Type, rawType: U.Type, result: @escaping (Result<[T], AppStateError>) -> Void) -> URLSessionTask? {

        guard let router = self.router else { result(Result.error(AppStateError.routerUnavailable)); return nil }
        var task: URLSessionTask?

        do {

            task = try router.request(api) { (data, response, error) in

                let httpResult = self.parseResponse(data: data, response: response, error: error)
                switch httpResult {
                case .value:

                    //API for GetAll must return Data
                    guard let notnil = data else {
                        result(Result.error(AppStateError.nullHttpResponseBody))
                        return
                    }

                    let parsed = self.parseCollection(notnil, objectType: T.self, rawType: U.self)
                    result(parsed)

                case .error(let appError): result(Result.error(appError))

                }

            }

        } catch { result(Result.error(AppStateError.invalidHttpRequest(apiName: String(describing: api)))) }

        return task

    }

    private func parseResponse(data: Data?, response: URLResponse?, error: Error?, apiName: String = #function) -> Result<Data?, AppStateError> {

        guard error == nil else { return Result.error(AppStateError.apiError(apiName: apiName)) }
        guard let httpResponse = response as? HTTPURLResponse else { return Result.error(AppStateError.nullHttpResponse) }

        guard let router = self.injector.appRouter() else { return Result.error(.routerUnavailable) }
        let httpResult = router.handleNetworkResponse(httpResponse)
        switch httpResult {
        case .value: return Result.value(data)
        case .error(let httpError): return Result.error(AppStateError.networkError(error: httpError))
        }

    }

    private func parseCollection<T: JsonConvertible, U: Codable>(_ data: Data, objectType: T.Type, rawType: U.Type) -> Result<[T], AppStateError> {

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        guard let parsedRaw = try? decoder.decode([U].self, from: data) else { return Result.error(AppStateError.invalidObjectData(type: "", data: data)) }

        do {

            let parsedDat = try parsedRaw.compactMap { try encoder.encode($0) }
            let parsedObjects = parsedDat.compactMap { T.init(from: $0) }
            return Result.value(parsedObjects)

        } catch { return Result.error(AppStateError.invalidObjectData(type: String(describing: U.self), data: data)) }

    }

    private func mustCallURLSessionTask(for key: String, tokenChanged: Bool) -> Bool {

        guard !tokenChanged else { return true }
        guard let task = self.taskBag[key] else { return true }
        if self.taskExecutionTimeIsUnderCircuitBreakLimit(taskStart: task.0) { return false }
        return true

    }

    private func taskExecutionTimeIsUnderCircuitBreakLimit(taskStart: Date) -> Bool {

        let now = Date()
        let circuitBreakLimit = taskStart.addingTimeInterval(self.circuitBreakLimit)
        return Calendar.current.compare(now, to: circuitBreakLimit, toGranularity: .second) == .orderedDescending

    }

    private static let keyInstitution = "taskIntitution"
    private static let keyUserInfo = "taskUserInfo"
    private static let keyMessages = "taskMessages"
    private static let keyDocuments = "taskDocuments"
    private static let keyNews = "taskNews"
    private static let keyComplaints = "taskComplaints"
    private static let keyRetirement = "taskRetirement"

}
