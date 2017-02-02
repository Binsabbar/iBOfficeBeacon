//
//  AppDelegateExtensions.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

extension AppDelegate: BITUpdateManagerDelegate {

    func setupHockyApp() {
        let featureName = FeatureToggles.HockeyAppIntegration.rawValue
        if let hockeyAppEnabled = wiring.settings().featureToggles[featureName]
        where hockeyAppEnabled {
            BITHockeyManager.sharedHockeyManager().configureWithIdentifier(wiring.settings().hockeyAppID, delegate: nil)
            
            BITHockeyManager.sharedHockeyManager().updateManager.updateSetting = .CheckManually
            BITHockeyManager.sharedHockeyManager().updateManager.checkForUpdateOnLaunch = false
            BITHockeyManager.sharedHockeyManager().updateManager.alwaysShowUpdateReminder = true
            BITHockeyManager.sharedHockeyManager().updateManager.showDirectInstallOption = true
            
            BITHockeyManager.sharedHockeyManager().startManager()
            
            BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
            BITHockeyManager.sharedHockeyManager().testIdentifier()
        }
    }
    
}
