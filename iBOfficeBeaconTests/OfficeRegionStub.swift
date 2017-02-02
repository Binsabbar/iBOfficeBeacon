//
//  MockOfficeBeacon.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 31/01/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

struct OfficeRegionStub: GenericOfficeRegion {
    var regionUUID: NSUUID
    var regionMajorID: Int
    var regionRooms: [Int: OfficeRoom]
    
    init(withBeacon beacon: CLBeaconStub, andRegionRooms rooms: [Int:OfficeRoom]) {
        regionUUID = beacon.proximityUUID
        regionMajorID = beacon.major.integerValue
        regionRooms = rooms
    }
    
    init(withRegion region: CLBeaconRegion, andRegionRooms rooms: [Int:OfficeRoom]) {
        regionUUID = region.proximityUUID
        regionMajorID = (region.major?.integerValue)!
        regionRooms = rooms
    }
    
    init(withUUID uuid: NSUUID, major: Int, rooms: [Int:OfficeRoom]) {
        regionUUID = uuid
        regionMajorID = major
        regionRooms = rooms
    }
}
