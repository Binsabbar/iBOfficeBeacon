//
//  TWBeaconServiceUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 20/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class TWBeaconServiceUnitTest: XCTestCase, TWBeaconServiceProtocol {
    
    var subject: TWBeaconService!
    var manager: ManagerDouble!
    var store: BeaconAddressStore!
    var appSettings: FakeAppSettings!
    
    var simulator: IBeaconEventSimulator!

    let region1 = CLBeaconRegionStub(withMajor: 12)
    let region2 = CLBeaconRegionStub(withMajor: 34)
    
    var beacons = [
        CLBeaconStub(withUUID: UUID(),
                    andMajor: NSNumber(value: arc4random() as UInt32).intValue,
                    andMinor: NSNumber(value: arc4random() as UInt32).intValue)
    ]
    
    var numberOfTimeExitCalled = 0
    var numberOfTimeEntersCalled = 0
    var numberOfTimesFoundRoomCalled = 0
    var numberOfTimesTimeoutIsCalled = 0
    
    override func setUp() {
        super.setUp()
        let fakeESTManager = FakeESTBeaconManager()
        manager = ManagerDouble(manager: fakeESTManager)
        store = BeaconAddressStoreDouble()
        simulator = IBeaconEventSimulator(estManager: fakeESTManager)
        appSettings = FakeAppSettings(environment: AppSettings.BUILD_ENVIRONMENT)
        subject = TWBeaconService(beaconManager: manager, beaconStore: store,
                                  appSettings: appSettings)
        subject.delegate = self
        
        numberOfTimesFoundRoomCalled = 0
        numberOfTimeExitCalled = 0
        numberOfTimeEntersCalled = 0
        numberOfTimesTimeoutIsCalled = 0
    }
    
    
    func testItCallsRoomFoundWhenRangingBeaconIsDone() {
        simulator.enter(region1).wait(hundredMs)
            .range(beacons, inRegion: region1)
        
        do { try subject.startRanging() } catch {}
        
        simulator.simulate()
        
        let expectation = self.expectation(description: "")
        fullfillExpectation(expectation, withinTime: twoSeconds)
        
        waitForExpectations(timeout: fiveSeconds) { _ in
            XCTAssertTrue(self.numberOfTimesFoundRoomCalled == 1)
        }
    }
    
    func testItThrowsErrorForMalformedBeaconUUID() {
        appSettings.fakeBeaconUUID = "not-valid-uuid"

        XCTAssertThrowsError(try subject.startRanging(), "") {
            (error: Error) in
            let anError = error as? MalformedBeaconUUIDError
            let errMessage = anError?.userInfo[NSLocalizedDescriptionKey] as! String
            XCTAssertTrue(errMessage.contains("not-valid-uuid"))
        }
    }
    
    //MARK: ServiceProtocol
    func foundRoom(_ room: OfficeRoom) { self.numberOfTimesFoundRoomCalled += 1 }
 
    //MARK: Double: BeaconProvider
    class BeaconAddressStoreDouble: BeaconAddressStore {
        override init() {
            super.init()
        }
        
        override var _offices: [OfficeAddress]? {
            get { return [OfficeAddress]() }
            set {}
        }
        
    }
    
    //MARK: Double: BeaconManager
    class ManagerDouble: BeaconManager {
    
        var callBack: compeletionHandler!
        fileprivate var eventHandler:TWBeaconEventDelegate?
        
        override init(manager: ESTBeaconManager) { super.init(manager: manager) }

        override func startRangingOnCompletion(_ onCompletion: @escaping compeletionHandler) {
                self.callBack = onCompletion
        }
        
        
        override func setBeaconTransitionEventsHandler(_ eventHandler: TWBeaconEventDelegate) {
            self.eventHandler = eventHandler
        }
        
        override func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
            self.callBack(beacons)
        }
        
    }
}
