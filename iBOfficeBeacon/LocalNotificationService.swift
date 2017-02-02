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
 
    private var application: UIApplication
    private var lastNotification: UILocalNotification?
    private var notificationSettings: UIUserNotificationSettings!
    
    init(application: UIApplication) {
        self.application = application
    }

    func registerNotification() {
        application.registerUserNotificationSettings(self.applicationNotificationSettings())
    }
    
    func fireNotification(message: String) {
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
    
    private func applicationNotificationSettings() -> UIUserNotificationSettings {
        if let settings = notificationSettings {
            return settings
        } else {
            notificationSettings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
            return notificationSettings
        }
    }
}
