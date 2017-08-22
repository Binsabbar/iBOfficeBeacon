//
//  FakeNotificationService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FakeNotificationService:LocalNotificationService {
    var fireNotificationCalled = false
    var clearLastNotificationCalled = false
    var clearLastNotificationCounter = 0
    
    var message: String?
    
    init() {
        clearLastNotificationCounter = 0
        super.init(application: UIApplication.shared)
    }
    
    override func fireNotification(_ message: String) {
        fireNotificationCalled = true
        self.message = message
    }
    
    override func clearLastNotification() {
        clearLastNotificationCalled = true
        clearLastNotificationCounter+=1
    }
}
