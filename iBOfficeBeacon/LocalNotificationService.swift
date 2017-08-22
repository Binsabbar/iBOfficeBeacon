//
//  LocalNotificationService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 21/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
import UIKit

class LocalNotificationService {
 
    fileprivate var application: UIApplication
    fileprivate var lastNotification: UILocalNotification?
    fileprivate var notificationSettings: UIUserNotificationSettings!
    
    init(application: UIApplication) {
        self.application = application
    }

    func registerNotification() {
        application.registerUserNotificationSettings(self.applicationNotificationSettings())
    }
    
    func fireNotification(_ message: String) {
        lastNotification = UILocalNotification()
        lastNotification!.alertTitle = "Room Entered"
        lastNotification!.alertBody = message
        application.presentLocalNotificationNow(lastNotification!)
    }
    
    func clearLastNotification() {
        if let notification = lastNotification {
            application.cancelLocalNotification(notification)
        }
    }
    
    fileprivate func applicationNotificationSettings() -> UIUserNotificationSettings {
        if let settings = notificationSettings {
            return settings
        } else {
            notificationSettings = UIUserNotificationSettings(types: .alert, categories: nil)
            return notificationSettings
        }
    }
}
