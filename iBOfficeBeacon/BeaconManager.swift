import Foundation

class BeaconManager: NSObject, ESTBeaconManagerDelegate {
    
    static var IMMEDIATE_ACCURACY = 0.5
    
    typealias compeletionHandler = ([CLBeacon]) -> Void
    
    private let manager: ESTBeaconManager
    
    private var eventHandler:TWBeaconEventDelegate?
    private var handler: compeletionHandler?
    
    private var regions = Set<CLBeaconRegion>()
    private var lastRangedBeacon: CLBeacon?
    
    init(manager: ESTBeaconManager) {
        self.manager = manager
        super.init()
        manager.delegate = self
    }
    
    func startRangingOnCompletion(onCompletion: compeletionHandler) {
        self.handler = onCompletion
        startRanging()
    }
    
    func setBeaconTransitionEventsHandler(eventHandler: TWBeaconEventDelegate){
        self.eventHandler = eventHandler
    }
    
    func addBeaconRegion(newRegion: CLBeaconRegion) {
        regions.insert(newRegion)
    }
    
    func clearBeaconRegions() {
        stopRanging()
        regions.removeAll()
    }
    
    func stopRanging() {
        regions.forEach {
            manager.stopRangingBeaconsInRegion($0)
        }
    }
    
    func resumeRanging() {
        startRanging()
    }
    
    //MARK: ESTBEaconManagerDelegate
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        guard isOur(region) else { return }
        
        let lastBeacon:CLBeacon? = selectLastRangedBeaconFrom(beacons)
        
        if let lastBeacon = lastBeacon where isBeaconOutOfRange(lastBeacon) {
            lastRangedBeacon = nil
            self.eventHandler?.movedAwayFromClosestBeacon()
        }
        else if let beacon = closestBeaconIn(beacons) where
            lastBeacon == nil || !isBeacon(beacon, equalTo: lastBeacon!) {
            self.lastRangedBeacon = beacon
            self.handler?([beacon])
        }
    }
    
    //MARK: helpers
    private func startRanging() {
        regions.forEach {
            manager.startRangingBeaconsInRegion($0)
        }
    }
    
    private func isBeaconOutOfRange(beacon: CLBeacon) -> Bool {
        return beacon.proximity != .Immediate &&
            beacon.accuracy > BeaconManager.IMMEDIATE_ACCURACY
    }
    
    private func isBeacon(beacon: CLBeacon, equalTo anotherBeacon: CLBeacon) -> Bool {
        return  anotherBeacon.proximityUUID == beacon.proximityUUID &&
            anotherBeacon.major == beacon.major &&
            anotherBeacon.minor == beacon.minor
    }
    
    private func isImmediate(beacon: CLBeacon) -> Bool {
        return beacon.proximity == .Immediate &&
            beacon.accuracy <= BeaconManager.IMMEDIATE_ACCURACY
    }
    
    private func isOur(region: CLBeaconRegion) -> Bool {
        return containsRegion(region)
    }

    private func closestBeaconIn(beacons: [CLBeacon]) -> CLBeacon? {
        var immediateBeacons = beacons.filter(isImmediate)
        if immediateBeacons.count == 0 { return nil }
        
        let firstBeacon = immediateBeacons.removeFirst()
        return immediateBeacons.reduce(firstBeacon, combine: closestBeacon)
    }
    
    
    private func closestBeacon(beacon: CLBeacon, anotherBeacon: CLBeacon) -> CLBeacon {
        return beacon.accuracy < anotherBeacon.accuracy ? beacon : anotherBeacon
    }
    
    private func containsRegion(anotherRegion: CLBeaconRegion) -> Bool {
        return regions.contains({ (aRegion) -> Bool in
            return aRegion.isEqualTo(anotherRegion)
        })
    }
    
    private func selectLastRangedBeaconFrom(beacons: [CLBeacon]) -> CLBeacon? {
        var selectedBeacon:CLBeacon? = nil
        if let lastBeacon = self.lastRangedBeacon {
            for beacon in beacons {
                if (isBeacon(beacon, equalTo: lastBeacon)) {
                    selectedBeacon = beacon
                    break
                }
            }
        }
        return selectedBeacon
    }
}
