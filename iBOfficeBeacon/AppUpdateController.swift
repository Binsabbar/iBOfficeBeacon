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
    
    var backgroundQueue: DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }
    
    init(updateManager manager: BITUpdateManager, settings: AppSettings){
        self.manager = manager
        self.settings = settings
    }
    
    func performUpdateCheckInBackground() {
        let toggleName = FeatureToggles.HockeyAppIntegration.rawValue
        if let hockeyAppIntegrationEnabled = settings.featureToggles[toggleName], hockeyAppIntegrationEnabled {
            backgroundQueue.async {
                if !self.hasUpdateBeenCheckedToday() {
                    self.manager.checkForUpdate()
                    self.updateUserSettings()
                }
            }
        }
    }
    
    fileprivate func updateUserSettings() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "AppUpdateCheckDate")
    }
    
    fileprivate func hasUpdateBeenCheckedToday() -> Bool {
        let defaults = UserDefaults.standard
        if let updateCheckDate = defaults.object(forKey: "AppUpdateCheckDate") as? Date {
            return updateCheckDate.compareDateToDayPrecision(Date()) == .orderedSame
        }
        return false
    }
}
