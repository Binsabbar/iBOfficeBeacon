//
//  AppUpdateController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class AppUpdateController {
    
    let manager: BITUpdateManager
    let settings: AppSettings
    
    var backgroundQueue: dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }
    
    init(updateManager manager: BITUpdateManager, settings: AppSettings){
        self.manager = manager
        self.settings = settings
    }
    
    func performUpdateCheckInBackground() {
        let toggleName = FeatureToggles.HockeyAppIntegration.rawValue
        if let hockeyAppIntegrationEnabled = settings.featureToggles[toggleName]
        where hockeyAppIntegrationEnabled {
            dispatch_async(backgroundQueue) {
                if !self.hasUpdateBeenCheckedToday() {
                    self.manager.checkForUpdate()
                    self.updateUserSettings()
                }
            }
        }
    }
    
    private func updateUserSettings() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSDate(), forKey: "AppUpdateCheckDate")
    }
    
    private func hasUpdateBeenCheckedToday() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let updateCheckDate = defaults.objectForKey("AppUpdateCheckDate") as? NSDate {
            return updateCheckDate.compareDateToDayPrecision(NSDate()) == .OrderedSame
        }
        return false
    }
}
