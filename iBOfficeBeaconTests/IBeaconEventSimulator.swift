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
    
    fileprivate var manager: FakeESTBeaconManager!
    
    fileprivate var callsParameters = [[AnyObject]]()
    fileprivate var determineStataParams = [CLRegionState]()
    
    fileprivate var callTracker = [FunctionName]()
    
    init(estManager: FakeESTBeaconManager){
        self.manager = estManager
    }
    
    func simulate() {
        let queue = DispatchQueue(label: "Simulator Invocation", attributes: [])
        queue.async { _ in
            for index in 0..<self.callTracker.count {
                let funcCall = self.callTracker[index]
                let params = self.callsParameters[index]
                self.invoke(funcCall, withParams: params)
            }
        }
    }
    
    func range(_ beacons:[CLBeacon], inRegion region: CLBeaconRegion) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.ragne)
        let params = [beacons, region] as [Any]
        callsParameters.append(params as [AnyObject])
        return self
    }
    
    func exit(_ region: CLBeaconRegion) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.onExit)
        let params = [region]
        callsParameters.append(params)
        return self
    }
    
    func enter(_ region: CLBeaconRegion) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.onEnter)
        let params = [region]
        callsParameters.append(params)
        return self
    }
    
    func wait(_ seconds:TimeInterval) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.wait)
        callsParameters.append([seconds as AnyObject])
        return self
    }
    
    func state(_ state: CLRegionState, forRegion region:CLBeaconRegion) -> IBeaconEventSimulator {
        callTracker.append(FunctionName.regionState)
        callsParameters.append([region])
        determineStataParams.append(state)
        return self
    }
 
    fileprivate func invoke(_ function : FunctionName, withParams params: [AnyObject]) {
        switch function {
        case .regionState:
            let state = determineStataParams.remove(at: 0)
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
            let seconds = params[0] as! TimeInterval
            Thread.sleep(forTimeInterval: seconds)
        }
    }
}
