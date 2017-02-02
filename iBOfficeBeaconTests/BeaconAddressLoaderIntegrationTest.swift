//
//  BeaconAddressLoaderIntegrationTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 20/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class BeaconAddressLoaderIntegrationTest: XCTestCase, BeaconAddressLoaderProtocol {

    typealias delegateAddressesLoadedSignature = ([[String: String]]?) -> Void
    
    var subject: BeaconAddressLoader!
    
    let notificationSelector = #selector(BeaconAddressLoaderIntegrationTest.notificationObserverMethod)
    
    var testExpectation: XCTestExpectation!
    var expectDelegateMethodAddressesLoadedTo: delegateAddressesLoadedSignature!
    var notificationIsFired: Bool!
    var fileService = FileService()
    
    var fetchedData = "Major,Minor,Office,Room,Calendar ID\n" +
                      "1,3,Manchester,Turing,calendarid@mail.com\n" +
                      "1,23, Manchester,Chillout,calendarid2@mail.com\n"
    
    var fetchedUnformattedData = ""
    
    var localFileName = "integration_test.txt"
    var sheetID = "Integration-Test-ID"
    var fileSerivce = FileService()

    override func setUp() {
        super.setUp()
        deleteFile(localFileName)
        notificationIsFired = false
        testExpectation = expectationWithDescription("BeaconAddressLoaderIntegrationTest")
    }

    override func tearDown() {
        super.tearDown()
        deleteFile(localFileName)
        assertFileIsDeleted(localFileName)
    }
    
    func testItLoadsBeaconAddresses() {
        assertFileIsDeleted(localFileName)
        setupSubjectWithTestData(fetchedData)
        
        expectDelegateMethodAddressesLoadedTo = { (addresses) in
            XCTAssertTrue(addresses!.count == 2)
            XCTAssertTrue(addresses![0]["Minor"] == "3")
            XCTAssertTrue(addresses![1]["Minor"] == "23")
            self.testExpectation.fulfill()
        }
        
        subject.loadBeaconAddressFromSheetWithID(sheetID)
        
        waitForExpectationsWithTimeout(hundredMs, handler: nil)
    }
    
    func testItLogsUserOutWhenFetchingRemoteFileFailsDueTo4XXErrors() {
        assertFileIsDeleted(localFileName)
        setupSubjectWithFetchingFileError()
        let appView = ViewControllerSpy()
        let loginView = ViewControllerSpy()
        let nvc = NavigationControllerBuilder.init().pushViewController(loginView)
            .pushViewController(appView)
            .build()
        
        subject.loadBeaconAddressFromSheetWithID(sheetID)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(nvc.viewControllers.count == 1)
            XCTAssertTrue(nvc.topViewController == loginView)
        }
    }
    
    func testItLogsUserOutWhenRequestingRemoteFileFailsDueTo4XXErrors() {
        assertFileIsDeleted(localFileName)
        setupSubjectWithRequestingFileError()
        let appView = ViewControllerSpy()
        let loginView = ViewControllerSpy()
        let nvc = NavigationControllerBuilder.init().pushViewController(loginView)
            .pushViewController(appView)
            .build()
        
        subject.loadBeaconAddressFromSheetWithID(sheetID)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(nvc.viewControllers.count == 1)
            XCTAssertTrue(nvc.topViewController == loginView)
        }
    }
    
    func testItPostsLoadingBeaconAddressFailedNotificationWhenFailingToParseBeaconAddresses() {
        let fakeFileService = FakeFileService()
        fakeFileService.mockWrongFullPathForFileName = true
        fileService = fakeFileService
        setupSubjectWithTestData(fetchedUnformattedData)
        
        
        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                         selector: notificationSelector,
                         name: BeaconAddressLoader.ParsingAddressFailed,
                         object: nil)
        
        subject.loadBeaconAddressFromSheetWithID(sheetID)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(self.notificationIsFired)
        }
    }
    
    func notificationObserverMethod() {
        notificationIsFired = true
    }
    
    //MARK: BeaconAddressLoaderProtocol
    func beaconAddressesLoaded(addresses: [[String: String]]?) {
        expectDelegateMethodAddressesLoadedTo?(addresses)
    }
    
    //MARK: helpers
    typealias MockHelper = ServiceDriveMockHelper
    
    private func setupSubjectWithRequestingFileError() {
        let error = NSErrorBuilder.createUnauthenticatedUseExceededError()
        let serviceDrive = MockHelper.mockDriveServiceRequestFileWithError(error)
        let driveClient = SheetDriveWrapper(withService: serviceDrive)
        
        let spreadsheetFactoryMethod:
            BeaconAddressLoader.SpreadsheetApiFactoryBlock = { (delegate) in
                return SpreadsheetAPI(remoteFileClient: driveClient,
                                      fileService: self.fileSerivce,
                                      delegate: delegate)
        }
        
        initSubject(spreadsheetFactoryMethod)
    }
    
    private func setupSubjectWithFetchingFileError() {
        let error = NSErrorBuilder.createUnauthenticatedUseExceededError()
        let serviceDrive = MockHelper.mockDriveFetchServiceWithError(error, forSheetID: self.sheetID)
        let driveClient = SheetDriveWrapper(withService: serviceDrive)
        
        let spreadsheetFactoryMethod:
            BeaconAddressLoader.SpreadsheetApiFactoryBlock = { (delegate) in
                return SpreadsheetAPI(remoteFileClient: driveClient,
                                      fileService: self.fileSerivce,
                                      delegate: delegate)
        }
        
        initSubject(spreadsheetFactoryMethod)
    }
    
    private func setupSubjectWithTestData(testData: String) {
        let serviceDrive = MockHelper.mockDriveFetchServiceWithRemoteData(testData, forSheetID: self.sheetID)
        let driveClient = SheetDriveWrapper(withService: serviceDrive)
        
        let spreadsheetFactoryMethod:
            BeaconAddressLoader.SpreadsheetApiFactoryBlock = { (delegate) in
                return SpreadsheetAPI(remoteFileClient: driveClient,
                                      fileService: self.fileSerivce,
                                      delegate: delegate)
        }
        
        initSubject(spreadsheetFactoryMethod)
    }
    
    private func initSubject(factory: BeaconAddressLoader.SpreadsheetApiFactoryBlock) {
        let errorHandler = GoogleAuthorizationErrorHandler(authController: AuthControllerSpy())
        subject = BeaconAddressLoader(spreadsheetApiCreate: factory,
                                      localFileName: localFileName,
                                      fileService: fileService,
                                      errorHandler: errorHandler)
        subject.delegate = self
    }
}
