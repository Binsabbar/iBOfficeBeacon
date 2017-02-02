//
//  FakeGoogleSettings.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FakeGoogleSettings: GoogleSettings {
    
    override init(clientID: String) {
        super.init(clientID: clientID)
        self.keychainItemName = AUTH_CONTROLLER_UT_KEYCHAIN_ITEM_NAME
    }
}
