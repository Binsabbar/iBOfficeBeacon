//
//  AuthControllerSpy.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 31/08/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class AuthControllerSpy: AuthController {
    
    fileprivate(set) var isLogoutCalled: Bool!
    
    init() {
        isLogoutCalled = false
        let fakeSettings = FakeGoogleSettings(clientID: "AuthControllerSpy")
        super.init(services: [], withSettings: fakeSettings)
    }
    
    override func logout() {
        isLogoutCalled = true
    }
}
