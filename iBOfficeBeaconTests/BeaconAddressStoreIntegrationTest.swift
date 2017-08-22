//
//  BeaconAddressStoreIntegrationTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 21/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class BeaconAddressStoreIntegrationTest: XCTestCase {
    
    var subject: BeaconAddressStore!
    
    var notificationIsFired = false
    let notificationSelector = #selector(BeaconAddressStoreIntegrationTest.notificationIsReceived)
    
    var mapper: BeaconAddressMapper!
    var loader: BeaconAddressLoader!

    typealias MockHelper = ServiceDriveMockHelper
    
    var fetchedData = "major,minor,office,room,calendar id\n" +
                      "1,3,Manchester,Turing,calendarid@mail.com\n" +
                      "1,23, Manchester,Chillout,chillout@mail.com\n" +
                      "3,63, London,Hive,hive@mail.com\n" +
                      "8,63, Birmingham,Hollala,hollala@mail.com\n"
    
    var localFileName = "integration_test.txt"
    var sheetID = "Integration-Test-ID"
    
    override func tearDown() {
        super.tearDown()
        deleteFile(localFileName)
        assertFileIsDeleted(localFileName)
    }

    func testItReturnsRoomGivenMajorAndMinor() {
        let serviceDrive = MockHelper.mockDriveFetchServiceWithRemoteData(self.fetchedData,
                                                                          forSheetID: self.sheetID)
        setupSubjectWithServiceDrive(serviceDrive)
        waitForAddressesToLoad()
        
        let room = subject.roomWithMajor(1, minor: 23)
        
        XCTAssertTrue(room?.name == "Chillout")
        XCTAssertTrue(room?.calendarID == "chillout@mail.com")
    }
    
    func testItPostsNotificationWhenOfficesAreSetDuringSubjectInitialisation() {
        let expectation = self.expectation(description: "BeaconAddressStoreTest")
        let serviceDrive = MockHelper.mockDriveFetchServiceWithRemoteData(self.fetchedData,
                                                                          forSheetID: self.sheetID)
        notificationIsFired = false
        NotificationCenter.default
            .addObserver(self, selector: notificationSelector,
                         name: NSNotification.Name(rawValue: BeaconAddressStore.OfficesUpdatedNotificationID),
                         object: subject)
        
        
        setupSubjectWithServiceDrive(serviceDrive)
        
        fullfillExpectation(expectation, withinTime: halfSecond)
    
        waitForExpectations(timeout: second) { _ in
            XCTAssertTrue(self.notificationIsFired)
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func notificationIsReceived(){
        notificationIsFired = true
    }
    
    //MARK: helpers
    fileprivate func waitForAddressesToLoad() {
        let timeout = Date(timeIntervalSinceNow: second)
        
        while timeout.compareDateToSecondPrecision(Date()) == .orderedDescending {
            RunLoop.current.run(until: Date().addingTimeInterval(hundredMs))
        }
    }
    
    fileprivate func setupSubjectWithServiceDrive(_ service: GTLRDriveService) {
        let spreadsheetFactoryBlock:
            BeaconAddressLoader.SpreadsheetApiFactoryBlock = { (delegate) in
                let serviceDrive = service
                let driveClient = SheetDriveWrapper(withService: serviceDrive)
                let fileService = FileService()
                return SpreadsheetAPI(remoteFileClient: driveClient,
                                      fileService: fileService,
                                      delegate: delegate)
        }
        
        loader = BeaconAddressLoader(spreadsheetApiCreate: spreadsheetFactoryBlock,
                                     localFileName: localFileName,
                                     fileService: FileService(),
                                     errorHandler: DummyErrorHandler())
        mapper = BeaconAddressMapper()
        
        subject = BeaconAddressStore(loader: loader, mapper: mapper,
                                     addressSheetID: sheetID)
    }
}
