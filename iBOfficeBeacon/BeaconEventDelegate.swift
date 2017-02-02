//
//  BeaconEventDelegate.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 08/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

public protocol TWBeaconEventDelegate:NSObjectProtocol {
    func movedAwayFromClosestBeacon() -> ()
}
