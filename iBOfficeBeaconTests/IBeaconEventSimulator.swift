//
//  IBeaconEventSimulator.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
enum FunctionName:Int{
    case regionState = 1
    case onEnter = 2
    case onExit = 3
    case ragne = 4
    case wait = 5
}


class IBeaconEventSimulator {
    
    private var manager: FakeESTBeaconManager!
    
    private var callsParameters = [[AnyObject]]()
    private var determineStataParams = [CLRegionState]()
    
    private var callTracker = [FunctionName]()
    
    init(estManager: FakeESTBeaconManager){
        self.manager = estManager
    }
    
    func simulate() {
        let queue = dispatch_queue_create("Simulator Invocation", nil)
        dispatch_async(queue) { _ in
            for index in 0..<self.callTracker.count {
                let funcCall = self.callTracker[index]
                let params = self.callsParameters[index]
                self.invoke(funcCall, withParams: params)
            }
        }
    }
    
    func range(beacons:[CLBeacon], inRegion region: CLBeaconRegion) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.ragne)
        let params = [beacons, region]
        callsParameters.append(params)
        return self
    }
    
    func exit(region: CLBeaconRegion) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.onExit)
        let params = [region]
        callsParameters.append(params)
        return self
    }
    
    func enter(region: CLBeaconRegion) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.onEnter)
        let params = [region]
        callsParameters.append(params)
        return self
    }
    
    func wait(seconds:NSTimeInterval) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.wait)
        callsParameters.append([seconds])
        return self
    }
    
    func state(state: CLRegionState, forRegion region:CLBeaconRegion) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.regionState)
        callsParameters.append([region])
        determineStataParams.append(state)
        return self
    }
 
    private func invoke(function : FunctionName, withParams params: [AnyObject]) {
        switch function {
        case .regionState:
            let state = determineStataParams.removeAtIndex(0)
            let region = params[0] as! CLBeaconRegion
            manager.mockDidDetermineState(state, forRegion: region)
        case .onEnter:
            let region = params[0] as! CLBeaconRegion
            manager.mockDidEnterRegion(region)
        case .onExit:
            let region = params[0] as! CLBeaconRegion
            manager.mockDidExitRegion(region)
        case .ragne:
            let beacons = params[0] as! [CLBeacon]
            let region = params[1] as! CLBeaconRegion
            manager.mockDidRangeBeacons(beacons, InRegion: region)
        case .wait:
            let seconds = params[0] as! NSTimeInterval
            NSThread.sleepForTimeInterval(seconds)
        }
    }
}
