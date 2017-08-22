//
//  Office.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 20/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class OfficeAddress {
    
    let major: Int
    let name: String
    var rooms: [OfficeRoom]
    
    init(name: String, major: Int) {
        self.name = name
        self.major = major
        self.rooms = [OfficeRoom]()
    }
    
    func addRoom(_ room: OfficeRoom) {
        self.rooms.append(room)
    }
}
