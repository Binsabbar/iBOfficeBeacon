//
//  GoogleAuthControllerSpy.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 23/08/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

class GoogleAuthControllerSpy: GoogleAuthController {
    
    fileprivate(set) var isLogoutCalled: Bool!
    
    init() {
        isLogoutCalled = false
        let fakeSettings = FakeGoogleSettings(clientID: "GoogleAuthControllerSpy")
        super.init(services: [], withSettings: fakeSettings)
    }
    
    override func logout() {
        isLogoutCalled = true
    }
    
}
