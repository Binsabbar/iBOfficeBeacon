//
//  CLBeaconRegionExtension.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 20/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

extension CLBeaconRegion {
    
    public func isEqualTo(region:CLBeaconRegion) -> Bool{
        return region.proximityUUID == self.proximityUUID
            && region.major == self.major
            && region.minor == self.minor
    }
}
