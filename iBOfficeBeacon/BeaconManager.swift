import Foundation

class BeaconManager: NSObject, ESTBeaconManagerDelegate {
    
    static var IMMEDIATE_ACCURACY = 0.5
    
    typealias compeletionHandler = ([CLBeacon]) -> Void
    
    fileprivate let manager: ESTBeaconManager
    
    fileprivate var eventHandler:TWBeaconEventDelegate?
    fileprivate var handler: compeletionHandler?
    
    fileprivate var regions = Set<CLBeaconRegion>()
    fileprivate var lastRangedBeacon: CLBeacon?
    
    init(manager: ESTBeaconManager) {
        self.manager = manager
        super.init()
        manager.delegate = self
    }
    
    func startRangingOnCompletion(_ onCompletion: @escaping compeletionHandler) {
        self.handler = onCompletion
        startRanging()
    }
    
    func setBeaconTransitionEventsHandler(_ eventHandler: TWBeaconEventDelegate){
        self.eventHandler = eventHandler
    }
    
    func addBeaconRegion(_ newRegion: CLBeaconRegion) {
        regions.insert(newRegion)
    }
    
    func clearBeaconRegions() {
        stopRanging()
        regions.removeAll()
    }
    
    func stopRanging() {
        regions.forEach {
            manager.stopRangingBeacons(in: $0)
        }
    }
    
    func resumeRanging() {
        startRanging()
    }
    
    //MARK: ESTBEaconManagerDelegate
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard isOur(region) else { return }
        
        let lastBeacon:CLBeacon? = selectLastRangedBeaconFrom(beacons)
        
        if let lastBeacon = lastBeacon, isBeaconOutOfRange(lastBeacon) {
            lastRangedBeacon = nil
            self.eventHandler?.movedAwayFromClosestBeacon()
        }
        else if let beacon = closestBeaconIn(beacons),
            lastBeacon == nil || !isBeacon(beacon, equalTo: lastBeacon!) {
            self.lastRangedBeacon = beacon
            self.handler?([beacon])
        }
    }
    
    //MARK: helpers
    fileprivate func startRanging() {
        regions.forEach {
            manager.startRangingBeacons(in: $0)
        }
    }
    
    fileprivate func isBeaconOutOfRange(_ beacon: CLBeacon) -> Bool {
        return beacon.proximity != .immediate &&
            beacon.accuracy > BeaconManager.IMMEDIATE_ACCURACY
    }
    
    fileprivate func isBeacon(_ beacon: CLBeacon, equalTo anotherBeacon: CLBeacon) -> Bool {
        return  anotherBeacon.proximityUUID == beacon.proximityUUID &&
            anotherBeacon.major == beacon.major &&
            anotherBeacon.minor == beacon.minor
    }
    
    fileprivate func isImmediate(_ beacon: CLBeacon) -> Bool {
        return beacon.proximity == .immediate &&
            beacon.accuracy <= BeaconManager.IMMEDIATE_ACCURACY
    }
    
    fileprivate func isOur(_ region: CLBeaconRegion) -> Bool {
        return containsRegion(region)
    }

    fileprivate func closestBeaconIn(_ beacons: [CLBeacon]) -> CLBeacon? {
        var immediateBeacons = beacons.filter(isImmediate)
        if immediateBeacons.count == 0 { return nil }
        
        let firstBeacon = immediateBeacons.removeFirst()
        return immediateBeacons.reduce(firstBeacon, closestBeacon)
    }
    
    
    fileprivate func closestBeacon(_ beacon: CLBeacon, anotherBeacon: CLBeacon) -> CLBeacon {
        return beacon.accuracy < anotherBeacon.accuracy ? beacon : anotherBeacon
    }
    
    fileprivate func containsRegion(_ anotherRegion: CLBeaconRegion) -> Bool {
        return regions.contains(where: { (aRegion) -> Bool in
            return aRegion.isEqualTo(anotherRegion)
        })
    }
    
    fileprivate func selectLastRangedBeaconFrom(_ beacons: [CLBeacon]) -> CLBeacon? {
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
