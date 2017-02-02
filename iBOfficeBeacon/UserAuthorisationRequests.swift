//
//  UserAuthorisationRequests.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 21/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
import UIKit
/**
 Work in Progress
 It had to be committed among other changes
 due to the way xcode orgnise files in the project
*/
class UserAuthorisationRequests: NSObject {
    
    var application: UIApplication
    
    init(application: UIApplication) {
        self.application = application
        super.init()
    }
    
    func registerNotificationAlert() {
        let notificationSetting = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        application.registerUserNotificationSettings(notificationSetting)
    }
    
    func requestBackgroundLocationService() {
        if (CLLocationManager.locationServicesEnabled()) {
            switch(CLLocationManager.authorizationStatus()){
            case .NotDetermined:
                // request location
                break
            case .Denied, .Restricted:
                print("need auth")
            case .AuthorizedAlways:
                print("Good")
            case .AuthorizedWhenInUse:
                print("hmmm")
            }
        } else {
            // Display alert showting that the app is not useable
        }
    }
}
