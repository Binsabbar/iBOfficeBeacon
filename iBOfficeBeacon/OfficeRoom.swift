//
//  OfficeRoom.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 06/12/2015.
//  Copyright © 2015 Binsabbar. All rights reserved.
//

import Foundation

class OfficeRoom {
    let name:String
    let calendarID: String
    let beaconMinor: Int
    
    var isUknown = false
    
    init(withName name: String, calendarID: String, minor: Int) {
        self.name = name
        self.calendarID = calendarID
        self.beaconMinor = minor
    }
    
    func isEqualTo(anotherRoom: OfficeRoom) -> Bool {
        return self.name == anotherRoom.name &&
            self.calendarID == anotherRoom.calendarID
    }
}
