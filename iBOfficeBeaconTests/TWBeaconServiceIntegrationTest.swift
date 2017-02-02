//
//  TWBeaconServiceIntegrationTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/12/2015.
//  Copyright © 2015 Binsabbar. All rights reserved.
//

import XCTest

class TWBeaconServiceIntegrationTest: XCTestCase, TWBeaconServiceProtocol {

    var subject: TWBeaconService!
    
    var simulator: IBeaconEventSimulator!
    var store: BeaconAddressStore!
    var fakeSettings = FakeAppSettings(environment: AppSettings.BUILD_ENVIRONMENT)
    var sheetID = "Integration-Test-ID"
    
    //MARK: delegate call checkers
    var isFoundRoomPassedInTheCallBack = false
    var isDeviceExitsRegionCalled = false
    var isDeviceEntersRegionCalled = false
    
    //MARK: Room details
    var regionUUID: NSUUID {
        return NSUUID(UUIDString: fakeSettings.beaconUUID)!
    }
    let officeMajor = 1
    let firstRoomMinor = 23
    let secondRoomMinor = 54
    let officeName = "Manchester"
    let firstRoomName = "First"
    let secondRoomName = "Second"

    var testSelectedRoom: OfficeRoom!
    
    //MARK: Tests
    override func setUp() {
        super.setUp()
        let beaconClient: FakeESTBeaconManager = FakeESTBeaconManager()
        simulator = IBeaconEventSimulator(estManager: beaconClient)
        let manager = BeaconManager(manager: beaconClient)
        setupBeaconAddressStore()
        
        subject = TWBeaconService(beaconManager: manager, beaconStore: store, appSettings: fakeSettings)
        subject.delegate = self
    
        testSelectedRoom = OfficeRoom(withName: firstRoomName, calendarID: "",
                                      minor: firstRoomMinor)
        
        setupBooleanVariablesToFalse()
    }
    
    func testItCallsItsDelegateWithTheFoundRoom() {
        let region = CLBeaconRegion(proximityUUID: regionUUID, identifier: "iBOfficeBeacon Tracking Region")
        simulator.wait(hundredMs).range(createCLBeacons(), inRegion: region)
        
        do { try subject.startRanging() } catch {}
        
        simulator.simulate()

        let expectation = expectationWithDescription("Calls Its Delegate when room is found")
        fullfillExpectation(expectation, withinTime: second)
        
        waitForExpectationsWithTimeout(twoSeconds) { _ in
            XCTAssertTrue(self.isFoundRoomPassedInTheCallBack)
        }
    }
    
    //MARK: Helper methods
    private func createCLBeacons() -> [CLBeaconStub] {
        let beacon = CLBeaconStub(withUUID: regionUUID,
                                  andMajor: officeMajor,
                                  andMinor: testSelectedRoom.beaconMinor)
        beacon.proximity = CLProximity.Immediate
        return [beacon]
    }
    
    //MARK: TWBeaconServiceProtocol
    func foundRoom(room: OfficeRoom) {
        isFoundRoomPassedInTheCallBack = room.name == testSelectedRoom.name &&
                                        room.beaconMinor == testSelectedRoom.beaconMinor
    }
    
    func deviceEntersRegion() { self.isDeviceEntersRegionCalled = true }
    func deviceExitsRegion() { self.isDeviceExitsRegionCalled = true }
    func timedoutRangingBeacons() { }
    
    
    // MARK: Setups
    private func setupBooleanVariablesToFalse() {
        isFoundRoomPassedInTheCallBack = false
        isDeviceExitsRegionCalled = false
        isDeviceEntersRegionCalled = false
    }
    
    var fetchedData:String {
        return "major,minor,office,room,calendar id\n" +
            "\(officeMajor),\(firstRoomMinor),\(officeName),\(firstRoomName),calendarid@mail.com\n" +
            "\(officeMajor),\(secondRoomMinor),\(officeName),\(secondRoomName),chillout@mail.com\n"
    }
    
    var localFileName = "integration_test.txt"
    private func setupBeaconAddressStore() {
        let spreadsheetFactoryBlock:
            BeaconAddressLoader.SpreadsheetApiFactoryBlock = { (delegate) in
                let serviceDrive = ServiceDriveMockHelper.mockDriveFetchServiceWithRemoteData(self.fetchedData,
                                                                                              forSheetID: self.sheetID)
                let driveClient = SheetDriveWrapper(withService: serviceDrive)
                let fileService = FileService()
                return SpreadsheetAPI(remoteFileClient: driveClient,
                                      fileService: fileService,
                                      delegate: delegate)
        }

        let loader = BeaconAddressLoader(spreadsheetApiCreate: spreadsheetFactoryBlock,
                                         localFileName: localFileName,
                                         fileService: FileService(),
                                         errorHandler: DummyErrorHandler())
        
        store = BeaconAddressStore(loader: loader, mapper: BeaconAddressMapper(), addressSheetID: sheetID)
    }
}
