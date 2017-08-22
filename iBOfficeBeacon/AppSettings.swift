//
//  AppSettings.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/12/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation


enum AppEnvironment: String {
    case Prod = "prod"
    case Test = "test"
    case Dev = "dev"
    case Default = "default"
}

enum FeatureToggles: String {
    case LocalNotificationProximity = "localNotificationProximity"
    case HockeyAppIntegration = "hockeyAppIntegration"
}

class AppSettings {
    
    fileprivate static var infoKey = "iBOfficeBeaconAppSettings"
    
    static var LOCAL_BEACON_ADDRESS_FILE_NAME = "officeAddresses.txt"
    class var BUILD_ENVIRONMENT: AppEnvironment {
        if let env = Bundle.main.infoDictionary?["BUILD_ENVIRONMENT"] as? String,
            let environment = AppEnvironment(rawValue: env) {
            return environment
        }
        return .Default
    }
    
    let environment: AppEnvironment
    let appInfo: [String:AnyObject]
    let infoDictionary = Bundle.main.infoDictionary
    
    var hockeyAppID: String {
        return valueForKey("HockeyAppID")
    }
    
    var googleSettings: GoogleSettings {
        return GoogleSettings(clientID: valueForKey("GoogleClientID"))
    }
    
    var addressSheetID: String {
        return valueForKey("AddressSheetID")
    }
    
    var beaconUUID: String {
        return valueForKey("BeaconUUID")
    }
    
    var featureToggles: [String: Bool] {
        return constructFeatureTogglesForCurrentEnvironment()
    }
    
    var buildEnvironment: String {
        if let buildEnv = infoDictionary?["BUILD_ENVIRONMENT"] as? String {
            return buildEnv
        }
        return "undefined"
    }
    
    var buildNumber: String {
        if let buildNum = infoDictionary?["CFBundleShortVersionString"] as? String {
            return buildNum
        }
        return "undefined"
    }
    
    init(environment: AppEnvironment) {
        self.environment = environment
        if let appInfo = infoDictionary?[AppSettings.infoKey] as? [String:AnyObject] {
            self.appInfo = appInfo
        } else {
            self.appInfo = [String:AnyObject]()
        }
    }
    
    fileprivate func constructFeatureTogglesForCurrentEnvironment() -> [String:Bool] {
        var featureToggles = [String:Bool]()
        
        if let features = appInfo["FeatureToggles"] as? [String: [String:Bool]] {
            
            features.forEach(){ (feature, environmentsToggles) in
                if let toggle = environmentsToggles[environment.rawValue] {
                    featureToggles[feature] = toggle
                }
            }
        }
        
        return featureToggles
    }
    
    fileprivate func valueForKey(_ key: String) -> String {
        
        if let value = appInfo[key] as? [String: String],
            let environmentValue = value[environment.rawValue] {
            return environmentValue
        }
        return "NOT_SET"
    }
}
