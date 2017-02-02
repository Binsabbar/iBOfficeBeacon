//
//  genericOfficeBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/12/2015.
//  Copyright © 2015 Binsabbar. All rights reserved.
//

import Foundation

struct GenericOfficeRegionBuilder {
    
    var regionUUID: NSUUID
    var regionMajorID: Int
    var regionRooms: [Int: OfficeRoom]
    var beacon:CLBeacon
    
    init(withBeacon beacon: CLBeaconStub, andRegionRooms rooms: [Int:OfficeRoom]) {
        regionUUID = beacon.proximityUUID
        regionMajorID = beacon.major.integerValue
        regionRooms = rooms
        self.beacon = beacon
    }
}


struct randomOfficeRegion {
    var regionUUID: NSUUID
    var regionMajorID: Int
    var regionRooms: [Int: OfficeRoom]
    
    init(uuid: NSUUID, major: Int, rooms: [Int:OfficeRoom]) {
        regionUUID = uuid
        regionMajorID = major
        regionRooms = rooms
    }
}
