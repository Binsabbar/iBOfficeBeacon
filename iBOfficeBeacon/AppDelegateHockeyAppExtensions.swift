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
        if let hockeyAppEnabled = wiring.settings().featureToggles[featureName], hockeyAppEnabled {
            BITHockeyManager.shared().configure(withIdentifier: wiring.settings().hockeyAppID, delegate: nil)
            
            BITHockeyManager.shared().updateManager.updateSetting = .checkManually
            BITHockeyManager.shared().updateManager.isCheckForUpdateOnLaunch = false
            BITHockeyManager.shared().updateManager.alwaysShowUpdateReminder = true
            BITHockeyManager.shared().updateManager.isShowingDirectInstallOption = true
            
            BITHockeyManager.shared().start()
            
            BITHockeyManager.shared().authenticator.authenticateInstallation()
            BITHockeyManager.shared().testIdentifier()
        }
    }
    
}
