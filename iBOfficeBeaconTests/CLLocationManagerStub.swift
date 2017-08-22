//
//  CCLocationManagerStub.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

class CLLocationManagerStub: CLLocationManager {
    
    static var currentStatus = CLAuthorizationStatus.authorizedAlways
    
    override class func authorizationStatus() -> CLAuthorizationStatus {
        return currentStatus
    }
    
    class func setStatus(_ status: CLAuthorizationStatus) {
        currentStatus = status
    }
}
