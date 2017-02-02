import XCTest

class BeaconManagerUnitTest: XCTestCase, TWBeaconEventDelegate {
    
    var subject:BeaconManager!
    
    var region:CLBeaconRegionStub!
    var anotherRegion:CLBeaconRegionStub!
    var encounteredBeacons:[CLBeaconStub]!
    var fakeESTManager: FakeESTBeaconManager!
    var simulator: IBeaconEventSimulator!
    
    var testUUID = NSUUID()
    var testUUID2 = NSUUID()
    var randomMajor = 12
    var randomMajor2 = 14
    
    var numberOfTimesHandlerCalled = 0
    var isMovedAwayFromClosestBeaconCalled = false
    let accuracyLargerThanImmediate = BeaconManager.IMMEDIATE_ACCURACY + 0.2
    
    override func setUp() {
        super.setUp()
        
        numberOfTimesHandlerCalled = 0
        isMovedAwayFromClosestBeaconCalled = false
        
        region = CLBeaconRegionStub(proximityUUID: testUUID, identifier: "test region 1")
        anotherRegion = CLBeaconRegionStub(proximityUUID: testUUID2, identifier: "test region 2")
        
        encounteredBeacons = [CLBeaconStub(withUUID: testUUID, andMajor: randomMajor, andProximity: .Immediate),
                              CLBeaconStub(withUUID: testUUID, andMajor: randomMajor2, andProximity: .Near)]

        fakeESTManager = FakeESTBeaconManager()
        simulator = IBeaconEventSimulator(estManager: fakeESTManager)
        
        subject = BeaconManager(manager: fakeESTManager)
        subject.clearBeaconRegions()
        subject.setBeaconTransitionEventsHandler(self)
        subject.addBeaconRegion(region)
    }
    
    
    //MARK: Implements ESTBeaconManagerDelegate
    func testSetItselfAsDelegateClassForESTBeaconManager () {
        XCTAssert(subject === fakeESTManager.delegate)
    }
    
    func testResponseToDelegateMethodDidRangeBeacon () {
        let selector = #selector(ESTBeaconManagerDelegate.beaconManager(_:didRangeBeacons:inRegion:))
        
        XCTAssertTrue(subject.respondsToSelector(selector), "Delegate method not implemented")
    }
    
    //MARK: #startRanging
    func testItDoesNotStartRangingWhenNoRegionIsAdded() {
        subject.clearBeaconRegions()

        subject.startRangingOnCompletion { _ in}
        
        XCTAssertFalse(fakeESTManager.isStartRangingBeaconsCalled)
    }
    
    func testItRangesBeaconsFromTheAddedRegions() {
        subject.addBeaconRegion(anotherRegion)
        
        subject.startRangingOnCompletion { _ in}
        
        XCTAssertTrue(fakeESTManager.isStartRangingBeaconsCalled)
        XCTAssertTrue(fakeESTManager.startRangingCalledWithRegions.contains(region))
        XCTAssertTrue(fakeESTManager.startRangingCalledWithRegions.contains(anotherRegion))
    }
    
    
    //MARK: #stopRanging
    func testItStopsRangingBeaconsFromTheAddedRegions() {
        subject.addBeaconRegion(anotherRegion)
        subject.startRangingOnCompletion { _ in}
        
        subject.stopRanging()

        XCTAssertTrue(fakeESTManager.isStopRangingBeaconsCalled)
        XCTAssertTrue(fakeESTManager.stopRangingCalledWithRegions.contains(region))
        XCTAssertTrue(fakeESTManager.stopRangingCalledWithRegions.contains(anotherRegion))
    }
    
    //MARK: #clearBeaconRegions
    func testStopsRangingWhenClearingBeaconRegions() {
        subject.clearBeaconRegions()
        
        XCTAssertTrue(fakeESTManager.isStopRangingBeaconsCalled)
        XCTAssertTrue(fakeESTManager.stopRangingCalledWithRegions.contains(region))
    }
    
    //MARK: #startRanging
    func testItResumeRangingBeaconsFromTheAddedRegions() {
        subject.startRangingOnCompletion { _ in}
        subject.stopRanging()
        
        subject.resumeRanging()
        
        let callStack:[FakeESTBeaconManagerMethods] = [
            .startRangingBeaconsInRegion,
            .stopRangingBeaconsInRegion,
            .startRangingBeaconsInRegion
        ]
        
        XCTAssertEqual(fakeESTManager.callStack, callStack)
    }
    
    //MARK: Call back CompeletionHandler when beacons are ranged
    func testCallsCompeletionBlockWhenTheClosestBeaconIsRanged() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        simulator.range(encounteredBeacons, inRegion: region)
        
        subject.startRangingOnCompletion(){ _ in expectation.fulfill() }
        
        simulator.simulate()
        
        waitForExpectationsWithTimeout(twoSeconds) { _ in }
    }
    
    func testCallsCompeletionBlockWhenANewBeaconBecomesTheClosest() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        let aCloseBeacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Immediate, accuracy: 0.12)
        let newCloseBeacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 12, proximity: .Immediate, accuracy: 0.22)
        
        simulator
            .range([aCloseBeacon], inRegion: region).wait(hundredMs)
            .range([newCloseBeacon], inRegion: region)
        
        subject.startRangingOnCompletion(){ (beacons) in
            self.numberOfTimesHandlerCalled += 1
            if self.numberOfTimesHandlerCalled == 2 {
                XCTAssertEqual(beacons.first, newCloseBeacon)
            }
        }
        
        simulator.simulate()
        
        fullfillExpectation(expectation, withinTime: second)
        waitForExpectationsWithTimeout(twoSeconds) { _ in
            XCTAssertEqual(self.numberOfTimesHandlerCalled, 2)
        }
    }
    
    func testItDoesNotCallCompeletionBlockTwiceIfSameBeaconIsEncounteredTwiceInSuccession() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        let beacon = CLBeaconStub(withUUID: testUUID, andMajor: randomMajor, andProximity: .Immediate)
        
        simulator.range([beacon], inRegion: region)
            .wait(hundredMs)
            .range([beacon], inRegion: region)
        
        subject.startRangingOnCompletion(){ (beacons) in
            self.numberOfTimesHandlerCalled += 1
        }
        
        simulator.simulate()
        
        fullfillExpectation(expectation, withinTime: second)
        waitForExpectationsWithTimeout(twoSeconds) { _ in
            XCTAssertEqual(self.numberOfTimesHandlerCalled, 1)
        }
    }
    
    func testItDoesNotCallCompeletionBlockWithBeaconsFromOtherRegions() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        simulator.range(encounteredBeacons, inRegion: anotherRegion)
        
        subject.startRangingOnCompletion(){ _ in XCTFail("Should not get called")}
        
        simulator.simulate()
        
        fullfillExpectation(expectation, withinTime: hundredMs)
        waitForExpectationsWithTimeout(second) { _ in }
    }
    

    func testItReturnsRangedBeaconsOnlyThoseWithImmedaiteProximity() {
        let expectation = expectationWithDescription("Return Immedaite Beacons")
        simulator.range(encounteredBeacons, inRegion: region)
        
        subject.startRangingOnCompletion(){ (beacons) in
            XCTAssertEqual(beacons.count, 1)
            XCTAssertTrue(beacons.first!.proximity == CLProximity.Immediate)
            expectation.fulfill()
        }
        
        simulator.simulate()
        
        waitForExpectationsWithTimeout(twoSeconds) { _ in}
    }
    
    func testItReturnsARangedBeaconOnlyThoseWithACertainAccuracy() {
        let expectation = expectationWithDescription("Return beacons with certain accuracy")
        subject.addBeaconRegion(region)
        simulator.range(encounteredBeacons, inRegion: region)
        
        subject.startRangingOnCompletion(){ (beacons) in
            XCTAssertEqual(beacons.count, 1)
            XCTAssertTrue(beacons.first!.accuracy <= BeaconManager.IMMEDIATE_ACCURACY)
            expectation.fulfill()
        }
        
        simulator.simulate()
        
        waitForExpectationsWithTimeout(twoSeconds) { _ in}
    }
    
    func testItReturnsTheClosestBeaconToTheDeviceWhenMultipleImmediateBeaconsAreEncountered() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        
        let beacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Immediate, accuracy: 0.12)
        let beaconTwo = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 2, proximity: .Immediate, accuracy: 0.22)
        let beaconThree = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 3, proximity: .Immediate, accuracy: 0.102)
        let beaconFour = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 3, proximity: .Near, accuracy: 0.312)
        
        simulator.range([beacon, beaconTwo, beaconThree, beaconFour], inRegion: region)
        
        subject.startRangingOnCompletion(){ (beacons) in
            XCTAssertEqual(beacons.count, 1)
            XCTAssertEqual(beacons.first?.minor, beaconThree.minor)
            expectation.fulfill()
        }
        
        simulator.simulate()
        
        waitForExpectationsWithTimeout(twoSeconds, handler: nil)
    }
    
    //MARK: When Devices moves away from beacon
    func testItInvokesDelegateWhenTheCloestBeaconBecomesAway() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        
        let aCloseBeacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Immediate, accuracy: 0.12)
        let aNearBeacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Near, accuracy: accuracyLargerThanImmediate)
        
        simulator.range([aCloseBeacon], inRegion: region).wait(second)
        .range([aNearBeacon], inRegion: region)
        
        subject.startRangingOnCompletion(){ _ in}
        
        simulator.simulate()
        
        fullfillExpectation(expectation, withinTime: twoSeconds)
        waitForExpectationsWithTimeout(second + twoSeconds){ _ in
            XCTAssertTrue(self.isMovedAwayFromClosestBeaconCalled)
        }
    }
    
    //MARK: When device moves back to the previous closest beacon after it moves away from it
    func testItCallsCompeletionHandler() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        let aCloseBeacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Immediate, accuracy: 0.12)
        let aNearBeacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Near, accuracy: accuracyLargerThanImmediate)
        
        simulator
            .range([aCloseBeacon], inRegion: region).wait(hundredMs)
            .range([aNearBeacon], inRegion: region).wait(hundredMs)
            .range([aCloseBeacon], inRegion: region)
        
        subject.startRangingOnCompletion(){ (beacons) in
            self.numberOfTimesHandlerCalled += 1
            XCTAssertEqual(beacons.first, aCloseBeacon)
        }
        
        simulator.simulate()
        
        fullfillExpectation(expectation, withinTime: twoSeconds)
        waitForExpectationsWithTimeout(second + twoSeconds){ _ in
            XCTAssertEqual(self.numberOfTimesHandlerCalled, 2)
        }
    }
    
    //MARK: When device is still theclosest to the beacon when ranging
    func testItDoesNotInvokeDelegateWhenTheCloestBeaconStillClose() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        
        let aCloseBeacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Immediate, accuracy: 0.12)
        let similarBeaconWithDiffAccuracy = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Immediate, accuracy: 0.22)
        
        simulator.range([aCloseBeacon], inRegion: region).wait(second)
            .range([similarBeaconWithDiffAccuracy], inRegion: region)
        
        subject.startRangingOnCompletion(){ _ in}
        
        simulator.simulate()
        
        fullfillExpectation(expectation, withinTime: twoSeconds)
        waitForExpectationsWithTimeout(second + twoSeconds){ _ in
            XCTAssertFalse(self.isMovedAwayFromClosestBeaconCalled)
        }
    }
    
    //MARK: When device is Near proximity, but NOT more than IMMEDIATE_ACCURACY away
    func testItDoesNotInvokeDelegateWhenBeaconIsNearButItIsNotAwayMoreThanImmediateAccuracy() {
        let expectation = expectationWithDescription("Compeletion Block Call")
        
        let aCloseBeacon = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Immediate, accuracy: 0.12)
        let similarBeaconWithDiffAccuracy = CLBeaconStub(uuid: testUUID, major: randomMajor, minor: 1, proximity: .Near, accuracy: BeaconManager.IMMEDIATE_ACCURACY - 0.2)
        
        simulator.range([aCloseBeacon], inRegion: region).wait(second)
            .range([similarBeaconWithDiffAccuracy], inRegion: region)
        
        subject.startRangingOnCompletion(){ _ in}
        
        simulator.simulate()
        
        fullfillExpectation(expectation, withinTime: twoSeconds)
        waitForExpectationsWithTimeout(second + twoSeconds){ _ in
            XCTAssertFalse(self.isMovedAwayFromClosestBeaconCalled)
        }
    }
    
    
    //MARK: Delegate
    func movedAwayFromClosestBeacon() {
        isMovedAwayFromClosestBeaconCalled = true
    }
    
}
