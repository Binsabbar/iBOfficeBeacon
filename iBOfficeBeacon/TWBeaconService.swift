//
//  TWBeaconService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 24/12/2015.
//  Copyright © 2015 Binsabbar. All rights reserved.
//

import Foundation

class TWBeaconService:NSObject {
    
    var delegate: TWBeaconServiceProtocol?
    
    private let manager: BeaconManager
    private let store: BeaconAddressStore
    private let appSettings: AppSettings
    
    init(beaconManager: BeaconManager, beaconStore: BeaconAddressStore,
         appSettings: AppSettings) {
        self.manager = beaconManager
        self.store = beaconStore
        self.appSettings = appSettings
        super.init()
    }
    
    func startRanging() throws -> Void {
        let uuid = NSUUID(UUIDString: self.appSettings.beaconUUID)
        
        guard let _ = uuid else {
            throw MalformedBeaconUUIDError(stringUUID: self.appSettings.beaconUUID)
        }
        
        let companyRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "iBOfficeBeacon Tracking Region")
        manager.addBeaconRegion(companyRegion)
        if store.offices != nil {
            self.startBeaconManagerRanging()
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TWBeaconService.startBeaconManagerRanging), name: BeaconAddressStore.OfficesUpdatedNotificationID, object: store)
        }
    }
    
    func startBeaconManagerRanging() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        manager.startRangingOnCompletion { (beacons) in
            let major = beacons.first!.major.integerValue
            let minor = beacons.first!.minor.integerValue
            let room = self.store.roomWithMajor(major, minor: minor)
            if let theRoom = room {
                self.delegate?.foundRoom(theRoom)
            } else {
                let unknownRoom = OfficeRoom(withName: "Unknown", calendarID: "", minor: minor)
                unknownRoom.isUknown = true
                self.delegate?.foundRoom(unknownRoom)
            }
        }
    }
}
