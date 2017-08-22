//
//  AppDelegateExtensions.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {

    func assignBeaconManagerForLaunchOptions(_ options: [AnyHashable: Any]?) {
        if let ft = wiring.settings().featureToggles[FeatureToggles.LocalNotificationProximity.rawValue], ft {
                wiring.localNotificationService().registerNotification()
        }
        
        if options != nil && options!.keys.contains(UIApplicationLaunchOptionsKey.location) {
            startBackgroundMonitoring()
        }
    }
    
    func assignBeaconManagerForInactiveState() {
        startBackgroundMonitoring()
    }
    
    func assignBeaconManagerForActiveState() {
        wiring.beaconManager().resumeRanging()
    }
    
    func startBackgroundMonitoring() {
        if let ft = wiring.settings().featureToggles[FeatureToggles.LocalNotificationProximity.rawValue] {
            if ft {
                wiring.localNotificationService().registerNotification()
                //TODO: WIP - Enable background monitoring story
            }
        }
    }
    
}
