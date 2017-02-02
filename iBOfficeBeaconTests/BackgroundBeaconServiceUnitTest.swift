//
//  BackgroundBeaconManagerUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 21/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class BackgroundBeaconServiceUnitTest: XCTestCase {
    
    var subject: BackgroundBeaconService!
    var fakeESTManager: FakeESTBeaconManager!
    var simulator: IBeaconEventSimulator!
    var notificationServ: FakeNotificationService!
    var officeStore: FakeBeaconAddressStore!
    
    let region = CLBeaconRegion(proximityUUID: NSUUID(), major: 1, minor: 2, identifier: "test")
    let region2 = CLBeaconRegion(proximityUUID: NSUUID(), major: 22, minor: 312, identifier: "test 2")
    var officeRoom: OfficeRoom!
    
    override func setUp() {
        super.setUp()
        officeRoom = OfficeRoom(withName: "BackgroundBeaconServiceUnitTest", calendarID: "ID", minor: 2)
        officeStore = FakeBeaconAddressStore()
        fakeESTManager = FakeESTBeaconManager()
        notificationServ = FakeNotificationService()
        
        subject = BackgroundBeaconService(withBeaconClient: fakeESTManager,
            andNotificationService: notificationServ, officeStore: officeStore)
        
        simulator = IBeaconEventSimulator(estManager: fakeESTManager)
    }
    
    func testItSetsItselfDelegateForBeaconClient() {
        subject.startBackgroundMonitoring()
        
        let clientDelegate = fakeESTManager.delegate as! BackgroundBeaconService
        
        XCTAssertTrue(subject! === clientDelegate)
    }
    
    func testItFiresNotificationOfTheRoomNameWhenDeviceEnterRegion() {
        simulator.enter(region).wait(hundredMs)
        officeStore.setRoom(officeRoom)
        
        subject.startBackgroundMonitoring()

        simulator.simulate()
        
        let expectation = expectationWithDescription("")
        fullfillExpectation(expectation, withinTime: halfSecond)
        waitForExpectationsWithTimeout(second) { _ in
            XCTAssertTrue(self.notificationServ.fireNotificationCalled)
            if let message = self.notificationServ.message {
                XCTAssertTrue(message.containsString(self.officeRoom.name))
            } else {
                XCTFail("Room name is not set")
            }
        }
    }
    
    func testItClearsLastNotificationWhenDeviceEnterNewRegionBeforeFiringNewOne() {
        simulator.enter(region).wait(hundredMs)
        officeStore.setRoom(officeRoom)
        
        subject.startBackgroundMonitoring()
        
        simulator.simulate()
        
        let expectation = expectationWithDescription("")
        fullfillExpectation(expectation, withinTime: halfSecond)
        waitForExpectationsWithTimeout(second) { _ in
            XCTAssertTrue(self.notificationServ.clearLastNotificationCalled)
        }
    }
    
    func testItClearsNotificationsWhenDeviceExitsRegion() {
        let onEnterClearCall = 1
        let onExitClearCall = 1
        let totalClearCalls = onEnterClearCall + onExitClearCall
        
        simulator.enter(region).wait(hundredMs).exit(region)
        officeStore.setRoom(officeRoom)
        
        subject.startBackgroundMonitoring()
        
        simulator.simulate()
        
        let expectation = expectationWithDescription("")
        fullfillExpectation(expectation, withinTime: halfSecond)
        waitForExpectationsWithTimeout(second) { _ in
            XCTAssertTrue(self.notificationServ.clearLastNotificationCalled)
            XCTAssertTrue(self.notificationServ.clearLastNotificationCounter == totalClearCalls)
        }
    }
    
    func testItClearNotificationOnExitOnlyForTheLastEnteredRegion() {
        let firstOnEnterClearCall = 1
        let secondOnEnterClearCall = 1
        let totalClearCalls = firstOnEnterClearCall + secondOnEnterClearCall
        
        simulator.enter(region).wait(hundredMs).enter(region2).wait(hundredMs)
            .exit(region)
        officeStore.setRoom(officeRoom)
        
        subject.startBackgroundMonitoring()
        
        simulator.simulate()
        
        let expectation = expectationWithDescription("")
        fullfillExpectation(expectation, withinTime: twoSeconds)
        waitForExpectationsWithTimeout(twoSeconds) { _ in
            XCTAssertTrue(self.notificationServ.clearLastNotificationCounter == totalClearCalls)
        }
    }
}

//MARK: Fake Classes for DI

class FakeBeaconAddressStore: BeaconAddressStore {
    
    var room: OfficeRoom!
    
    func setRoom(room: OfficeRoom) {
        self.room = room
    }
    
    override func roomWithMajor(major: Int, minor: Int) -> OfficeRoom? {
        return room
    }
}
