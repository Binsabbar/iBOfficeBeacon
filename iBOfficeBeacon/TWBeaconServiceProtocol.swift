//
//  TWBeaconServiceProtocol.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 21/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

protocol TWBeaconServiceProtocol:NSObjectProtocol {
    func foundRoom(_ room: OfficeRoom)->Void
}
