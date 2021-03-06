//
//  GoogleSettings.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class GoogleSettings {
    
    let clientID: String
    var keychainItemName = "Google Calendar API"
    
    let _scopes = [kGTLRAuthScopeCalendar, kGTLRAuthScopeDriveReadonly]
    var scopes: String {
        get {
            return self._scopes.joined(separator: " ")
        }
    }
    
    init(clientID: String){
        self.clientID = clientID
    }
}
