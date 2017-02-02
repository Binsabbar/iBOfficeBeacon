//
//  MockESTBeaconManager.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 31/01/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

enum FakeESTBeaconManagerMethods:Int {
    case startRangingBeaconsInRegion
    case stopRangingBeaconsInRegion
    case stopMonitoringForRegion
    case startMonitoringForRegion
}

class FakeESTBeaconManager: ESTBeaconManager {
    let queue:dispatch_queue_t!
    
    var beaconRegions:[CLBeaconRegion] = []
    var rangedBeaconRegions = Set<CLBeaconRegion>()
    var monitoredBeaconRegions = Set<CLBeaconRegion>()
    var startRangingCalledWithRegions = Set<CLBeaconRegion>()
    var stopRangingCalledWithRegions = Set<CLBeaconRegion>()
    
    var state:CLRegionState = CLRegionState.Unknown
    
    var isDetermineRegionStateCalled = false
    var isStartMonitorRegionCalled = false
    var isStopMonitorRegionCalled = false
    var isStopRangingBeaconsCalled = false
    var isStartRangingBeaconsCalled = false
    var requestWhenInUseAuthorizationIsCalled = false
    
    var callStack:[FakeESTBeaconManagerMethods] = []
    
    override init() {
        queue = dispatch_queue_create("FakeESTManagerQueueTest", nil)
        super.init()
    }
    
    // MARK: Override CLLocation methods
    override func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationIsCalled = true
    }
    
    override func startRangingBeaconsInRegion(region: CLBeaconRegion) {
        callStack.append(.startRangingBeaconsInRegion)
        isStartRangingBeaconsCalled = true
        startRangingCalledWithRegions.insert(region)
        super.startRangingBeaconsInRegion(region)
    }
    
    override func startMonitoringForRegion(region: CLBeaconRegion) {
        callStack.append(.startMonitoringForRegion)
        isStartMonitorRegionCalled = true
        super.startMonitoringForRegion(region)
    }
    
    override func stopMonitoringForRegion(region: CLBeaconRegion) {
        self.isStopMonitorRegionCalled = true
        callStack.append(.stopMonitoringForRegion)
        super.stopRangingBeaconsInRegion(region)
    }
    
    override func stopRangingBeaconsInRegion(region: CLBeaconRegion) {
        self.isStopRangingBeaconsCalled = true
        callStack.append(.stopRangingBeaconsInRegion)
        stopRangingCalledWithRegions.insert(region)
        super.stopRangingBeaconsInRegion(region)
    }
    
    // MARK: Mockign delegate calls in main thread
    func mockDidExitRegion(region: CLBeaconRegion) {
        self.mockDidDetermineState(CLRegionState.Outside, forRegion: region)
        if let del = delegate {
            dispatch_async(queue) {
                del.beaconManager?(self, didExitRegion: region)
            }
        }
    }
    
    func mockDidEnterRegion(region: CLBeaconRegion) {
        self.mockDidDetermineState(CLRegionState.Inside, forRegion: region)
        if let del = delegate {
            if del.respondsToSelector(#selector(ESTBeaconManagerDelegate.beaconManager(_:didEnterRegion:))) {
                dispatch_async(queue) {
                    del.beaconManager?(self, didEnterRegion: region)
                }
            }
        }
    }
    
    func mockDidDetermineState(state: CLRegionState, forRegion region: CLBeaconRegion) {
        if let del = delegate {
            dispatch_async(dispatch_get_main_queue()) {
                del.beaconManager?(self, didDetermineState: state, forRegion: region)
            }
        }
    }
    
    func mockDidRangeBeacons(beacons:[CLBeacon], InRegion region:CLBeaconRegion) {
        if let del = delegate {
            dispatch_async(dispatch_get_main_queue()) {
                del.beaconManager?(self, didRangeBeacons: beacons, inRegion: region)
            }
        }
    }
}
