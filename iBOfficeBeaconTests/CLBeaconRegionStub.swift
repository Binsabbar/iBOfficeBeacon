//
//  StubBeacon.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 16/05/2015.
//  Copyright (c) 2015 Binsabbar. All rights reserved.
//

import Foundation

class CLBeaconRegionStub: CLBeaconRegion {
    
    let randomUUIDString = "68753A44-4D6F-1226-9C60-0050E4C00067"
    
    override init(){
        let beaconUUID:UUID = UUID(uuidString: randomUUIDString)!
        super.init(proximityUUID: beaconUUID, identifier: "ID 1")
    }

    override init(proximityUUID: UUID, identifier: String){
        super.init(proximityUUID: proximityUUID, identifier: identifier)
    }
    
    override init(proximityUUID: UUID, major:CLBeaconMajorValue, identifier: String) {
        super.init(proximityUUID: proximityUUID, major: major, identifier: identifier)
    }
    
    init(withMajor major:CLBeaconMajorValue) {
        let beaconUUID:UUID = UUID(uuidString: randomUUIDString)!
        super.init(proximityUUID: beaconUUID, major: major, identifier: "ID\(major)")
    }
    
    init(withMajor major:CLBeaconMajorValue, andMinor minor: CLBeaconMinorValue) {
        let beaconUUID:UUID = UUID()
        super.init(proximityUUID: beaconUUID, major: major, minor: minor, identifier: "ID\(major)\(minor)")
     }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
