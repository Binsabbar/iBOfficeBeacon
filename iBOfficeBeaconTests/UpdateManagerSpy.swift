//
//  UpdateManagerSpy.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class UpdateManagerSpy:BITUpdateManager {
    
    var checkForUpdateCalled = false
    var showUpdateViewCalled = false
    
    override func checkForUpdate() {
        checkForUpdateCalled = true
    }
    
}
