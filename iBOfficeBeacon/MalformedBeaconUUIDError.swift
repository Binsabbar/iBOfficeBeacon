//  MalformedBeaconUUIDError.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 23/12/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.

import Foundation

class MalformedBeaconUUIDError: NSError {

    init(stringUUID: String) {
        let errorMessage = stringUUID.isEmpty ?
            "Beacon UUID is empty":"Malformed UUID: \(stringUUID)"
        
        let domain = "iBOfficeBeacon.BeaconService"
        let userInfo = [NSLocalizedDescriptionKey: errorMessage]
        super.init(domain: domain, code: 1, userInfo: userInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
