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
    let queue:DispatchQueue!
    
    var beaconRegions:[CLBeaconRegion] = []
    var rangedBeaconRegions = Set<CLBeaconRegion>()
    var monitoredBeaconRegions = Set<CLBeaconRegion>()
    var startRangingCalledWithRegions = Set<CLBeaconRegion>()
    var stopRangingCalledWithRegions = Set<CLBeaconRegion>()
    
    var state:CLRegionState = CLRegionState.unknown
    
    var isDetermineRegionStateCalled = false
    var isStartMonitorRegionCalled = false
    var isStopMonitorRegionCalled = false
    var isStopRangingBeaconsCalled = false
    var isStartRangingBeaconsCalled = false
    var requestWhenInUseAuthorizationIsCalled = false
    
    var callStack:[FakeESTBeaconManagerMethods] = []
    
    override init() {
        queue = DispatchQueue(label: "FakeESTManagerQueueTest", attributes: [])
        super.init()
    }
    
    // MARK: Override CLLocation methods
    override func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationIsCalled = true
    }
    
    override func startRangingBeacons(in region: CLBeaconRegion) {
        callStack.append(.startRangingBeaconsInRegion)
        isStartRangingBeaconsCalled = true
        startRangingCalledWithRegions.insert(region)
        super.startRangingBeacons(in: region)
    }
    
    override func startMonitoring(for region: CLBeaconRegion) {
        callStack.append(.startMonitoringForRegion)
        isStartMonitorRegionCalled = true
        super.startMonitoring(for: region)
    }
    
    override func stopMonitoring(for region: CLBeaconRegion) {
        self.isStopMonitorRegionCalled = true
        callStack.append(.stopMonitoringForRegion)
        super.stopRangingBeacons(in: region)
    }
    
    override func stopRangingBeacons(in region: CLBeaconRegion) {
        self.isStopRangingBeaconsCalled = true
        callStack.append(.stopRangingBeaconsInRegion)
        stopRangingCalledWithRegions.insert(region)
        super.stopRangingBeacons(in: region)
    }
    
    // MARK: Mockign delegate calls in main thread
    func mockDidExitRegion(_ region: CLBeaconRegion) {
        self.mockDidDetermineState(CLRegionState.outside, forRegion: region)
        if let del = delegate {
            queue.async {
                del.beaconManager?(self, didExitRegion: region)
            }
        }
    }
    
    func mockDidEnterRegion(_ region: CLBeaconRegion) {
        self.mockDidDetermineState(CLRegionState.inside, forRegion: region)
        if let del = delegate {
            if del.responds(to: #selector(ESTBeaconManagerDelegate.beaconManager(_:didEnter:))) {
                queue.async {
                    del.beaconManager?(self, didEnter: region)
                }
            }
        }
    }
    
    func mockDidDetermineState(_ state: CLRegionState, forRegion region: CLBeaconRegion) {
        if let del = delegate {
            DispatchQueue.main.async {
                del.beaconManager?(self, didDetermineState: state, for: region)
            }
        }
    }
    
    func mockDidRangeBeacons(_ beacons:[CLBeacon], InRegion region:CLBeaconRegion) {
        if let del = delegate {
            DispatchQueue.main.async {
                del.beaconManager?(self, didRangeBeacons: beacons, in: region)
            }
        }
    }
}
