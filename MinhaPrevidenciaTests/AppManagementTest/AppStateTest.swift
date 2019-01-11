//
//  AppStateTest.swift
//  MinhaPrevidenciaTests
//
//  Created by Gustavo Tavares on 09/01/2019.
//  Copyright © 2019 brClouders. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import MinhaPrevidencia

class AppStateTest: XCTestCase {

//    var mockBackend: BackendMock?
//    var session: URLSession?
    var sut: AppState?

    var bag = DisposeBag()

    override func setUp() { self.sut = self.configureSut() }

    override func tearDown() { }

    func testStubbedData() {

        let data = self.stubbedData()
        XCTAssert(data.count > 0, "Empty Stubbbed Data")

    }

    func testAppStateInitialization() {

        XCTAssertNotNil(self.sut)

        let expectInstitution = expectation(description: "Institutional Initial Data is available")
        let expectUserInfo = expectation(description: "UserInfo Initial Data is available")
        let expectMessages = expectation(description: "Messages Initial Data is available")
        let expectDocuments = expectation(description: "Documents Initial Data is available")
        let expectNews = expectation(description: "News Initial Data is available")
        let expectComplaints = expectation(description: "Complaints Initial Data is available")
        let expectRetirement = expectation(description: "Retirement Initial Data is available")

        self.sut?.institution.subscribe(onNext: { _ in expectInstitution.fulfill() }).disposed(by: bag)
        self.sut?.userInfo.subscribe(onNext: { _ in expectUserInfo.fulfill() }).disposed(by: bag)
        self.sut?.messages.subscribe(onNext: { _ in expectMessages.fulfill() }).disposed(by: bag)
        self.sut?.documents.subscribe(onNext: { _ in expectDocuments.fulfill() }).disposed(by: bag)
        self.sut?.news.subscribe(onNext: { _ in expectNews.fulfill() }).disposed(by: bag)
        self.sut?.complaints.subscribe(onNext: { _ in expectComplaints.fulfill() }).disposed(by: bag)
        self.sut?.retirement.subscribe(onNext: { _ in expectRetirement.fulfill() }).disposed(by: bag)

        waitForExpectations(timeout: 5.0, handler: nil)

    }

    func testCheckInstitutionRefresh() {

        let expectEvents = expectation(description: "Subject must emit 2 events (skipping 1st)")
        self.sut?.institution.skip(1).subscribe(onNext: { _ in expectEvents.fulfill() }).disposed(by: self.bag)
        sut?.refreshInstitution()
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testCheckUserInfoRefresh() {

        let expectEvents = expectation(description: "Subject must emit 2 events (skipping 1st)")
        self.sut?.userInfo.skip(1).subscribe(onNext: { _ in expectEvents.fulfill() }).disposed(by: self.bag)
        sut?.refreshUserInfo()
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testCheckMessagesRefresh() {

        let expectEvents = expectation(description: "Subject must emit 2 events (skipping 1st)")
        self.sut?.messages.skip(1).subscribe(onNext: { _ in expectEvents.fulfill() }).disposed(by: self.bag)
        sut?.refreshMessages()
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testCheckDocumentsRefresh() {

        let expectEvents = expectation(description: "Subject must emit 2 events (skipping 1st)")
        self.sut?.documents.skip(1).subscribe(onNext: { _ in expectEvents.fulfill() }).disposed(by: self.bag)
        sut?.refreshDocuments()
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testCheckNewsRefresh() {

        let expectEvents = expectation(description: "Subject must emit 2 events (skipping 1st)")
        self.sut?.news.skip(1).subscribe(onNext: { _ in expectEvents.fulfill() }).disposed(by: self.bag)
        sut?.refreshNews()
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testCheckComplaintsRefresh() {

        let expectEvents = expectation(description: "Subject must emit 2 events (skipping 1st)")
        self.sut?.complaints.skip(1).subscribe(onNext: { _ in expectEvents.fulfill() }).disposed(by: self.bag)
        sut?.refreshComplaints()
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testCheckRetirementRefresh() {

        let expectEvents = expectation(description: "Subject must emit 2 events (skipping 1st)")
        self.sut?.retirement.skip(1).subscribe(onNext: { _ in expectEvents.fulfill() }).disposed(by: self.bag)
        sut?.refreshRetirement()
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testRefreshAll() {

        let expectInstitution = expectation(description: "Institution must be Refreshed")
        let expectUserInfo = expectation(description: "UserInfo must be Refreshed")
        let expectMessages = expectation(description: "Messages must be Refreshed")
        let expectDocuments = expectation(description: "Documents must be Refreshed")
        let expectNews = expectation(description: "News must be Refreshed")
        let expectComplaints = expectation(description: "Complaints must be Refreshed")
        let expectRetirement = expectation(description: "Retirement must be Refreshed")

        self.sut?.institution.skip(1).subscribe(onNext: { _ in expectInstitution.fulfill()}).disposed(by: self.bag)
        self.sut?.userInfo.skip(1).subscribe(onNext: { _ in expectUserInfo.fulfill()}).disposed(by: self.bag)
        self.sut?.messages.skip(1).subscribe(onNext: { _ in expectMessages.fulfill()}).disposed(by: self.bag)
        self.sut?.documents.skip(1).subscribe(onNext: { _ in expectDocuments.fulfill()}).disposed(by: self.bag)
        self.sut?.news.skip(1).subscribe(onNext: { _ in expectNews.fulfill()}).disposed(by: self.bag)
        self.sut?.complaints.skip(1).subscribe(onNext: { _ in expectComplaints.fulfill()}).disposed(by: self.bag)
        self.sut?.retirement.skip(1).subscribe(onNext: { _ in expectRetirement.fulfill()}).disposed(by: self.bag)

        sut?.refresh()

        waitForExpectations(timeout: 15, handler: nil)

    }

    func testStartObservables() {

        let isolatedSut = self.configureSut()

        var counterInstitution = 0
        var counterUserInfo = 0
        var counterMessages = 0
        var counterDocuments = 0
        var counterNews = 0
        var counterComplaints = 0
        var counterRetirement = 0

        let expectInstitution = expectation(description: "Institution must be Refreshed")
        let expectUserInfo = expectation(description: "UserInfo must be Refreshed")
        let expectMessages = expectation(description: "Messages must be Refreshed")
        let expectDocuments = expectation(description: "Documents must be Refreshed")
        let expectNews = expectation(description: "News must be Refreshed")
        let expectComplaints = expectation(description: "Complaints must be Refreshed")
        let expectRetirement = expectation(description: "Retirement must be Refreshed")

        isolatedSut.institution.skip(1).subscribe(onNext: { _ in counterInstitution += 1; if counterInstitution == 2 {expectInstitution.fulfill()}}).disposed(by: self.bag)
        isolatedSut.userInfo.skip(1).subscribe(onNext: { _ in counterUserInfo += 1; if counterUserInfo == 2 {expectUserInfo.fulfill()}}).disposed(by: self.bag)
        isolatedSut.messages.skip(1).subscribe(onNext: { _ in counterMessages += 1; if counterMessages == 2 {expectMessages.fulfill()}}).disposed(by: self.bag)
        isolatedSut.documents.skip(1).subscribe(onNext: { _ in counterDocuments += 1; if counterDocuments == 2 {expectDocuments.fulfill()}}).disposed(by: self.bag)
        isolatedSut.news.skip(1).subscribe(onNext: { _ in counterNews += 1; if counterNews == 2 {expectNews.fulfill()}}).disposed(by: self.bag)
        isolatedSut.complaints.skip(1).subscribe(onNext: { _ in counterComplaints += 1; if counterComplaints == 2 {expectComplaints.fulfill()}}).disposed(by: self.bag)
        isolatedSut.retirement.skip(1).subscribe(onNext: { _ in counterRetirement += 1; if counterRetirement == 2 {expectRetirement.fulfill()}}).disposed(by: self.bag)

        isolatedSut.startObservables()

        waitForExpectations(timeout: 15, handler: nil)

    }

    func testStopObservables() {

        let isolatedSut = self.configureSut()

        var counterInstitution = 0
        let expectInstitution = expectation(description: "Institution must be Refreshed")

        isolatedSut.institution.skip(1).subscribe(onNext: { _ in counterInstitution += 1; if counterInstitution > 1 {expectInstitution.fulfill()}}).disposed(by: self.bag)

        isolatedSut.startObservables()
        waitForExpectations(timeout: 15, handler: nil)

        isolatedSut.pauseObservables()
        let expectInstitutionNoCalled = expectation(description: "Institution must be Refreshed")
        expectInstitutionNoCalled.isInverted = true
        var alreadyCalled: Bool = false

        isolatedSut.institution.skip(1).subscribe(onNext: { _ in
            if !alreadyCalled { expectInstitutionNoCalled.fulfill(); alreadyCalled = true}
        }).disposed(by: self.bag)

        waitForExpectations(timeout: 3, handler: nil)

    }

    func stubbedData() -> [URL: Data] {

        let nsmutable = NSMutableDictionary()
        nsmutable.addEntries(from: ComplaintEndpointTest().stubbedData())
        nsmutable.addEntries(from: CommunicationMessageEndpointTest().stubbedData())
        nsmutable.addEntries(from: DocumentEndpointTest().stubbedData())
        nsmutable.addEntries(from: InstitutionEndpointTest().stubbedData())
        nsmutable.addEntries(from: NewsReportEndpointTest().stubbedData())
        nsmutable.addEntries(from: RetirementEndpointTest().stubbedData())
        nsmutable.addEntries(from: UserProfileEndpointTest().stubbedData())

        // swiftlint:disable identifier_name
        var stubbed: [URL: Data] = [:]
        for (k, v) in nsmutable {

            if let key = k as? URL, let value = v as? Data { stubbed[key] = value }

        }

        return stubbed

    }

    private func configureSut() -> AppState {

        let mockBackend = BackendMock(database: self.stubbedData())
        let session = MockedURLSession(validator: mockBackend.validator)
        let coredata = MockedCoreDataStack.shared
        let injector = MockedInjector(session: session, dataStoreManager: coredata.manager)

        return AppState(injector: injector)

    }

}
