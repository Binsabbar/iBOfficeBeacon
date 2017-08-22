//
//  FakeAppSettings.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/12/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FakeAppSettings: AppSettings {
    
    var fakeBeaconUUID = "fa23bfa6-c52d-11e6-a4a6-cec0c932ce01"
    var fakeFeatureToggles = [String:Bool]()
    
    override var beaconUUID: String {
        return fakeBeaconUUID
    }
    
    func setFeautreToggle(_ feature: FeatureToggles, To value: Bool) {
        fakeFeatureToggles[feature.rawValue] = value
    }
    
    override var featureToggles: [String: Bool] {
        return fakeFeatureToggles
    }
}
