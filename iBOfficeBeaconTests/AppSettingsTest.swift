//
//  AppSettingsTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/12/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class AppSettingsTest: XCTestCase {
    
    var appSettings: AppSettings!
    
    func testItReturnsHockeyAppID() {
        appSettings = AppSettings(environment: .Default)
        
        let hockeyAppID = appSettings.hockeyAppID
        
        XCTAssertEqual(hockeyAppID, "set your hockey app id for the environment")
    }
    
    func testItReturnsGoogleClientID() {
        appSettings = AppSettings(environment: .Default)
        
        let googleSettins = appSettings.googleSettings
        
        XCTAssertEqual(googleSettins.clientID, "set your googleClientID for the environment")
    }
    
    func testItReturnsAddressSheetID() {
        appSettings = AppSettings(environment: .Default)
        
        let addressSheetID = appSettings.addressSheetID
        
        XCTAssertEqual(addressSheetID, "set your addressSheetID for the environment")
    }
    
    func testItReturnsBeaconUUID() {
        appSettings = AppSettings(environment: .Default)
        
        let beaconUUID = appSettings.beaconUUID
        
        XCTAssertEqual(beaconUUID, "set your beaconUUID for the environment")
    }
    
    func testItReturnsFeatureToggles() {
        appSettings = AppSettings(environment: .Default)
        
        let featureToggles = appSettings.featureToggles
        
        XCTAssertTrue(featureToggles.contains(where: {$0.0 == "localNotificationProximity"}))
        XCTAssertTrue(featureToggles.contains(where: {$0.0 == "hockeyAppIntegration"}))
    }
    
    func testItReturnsBuildEnvironment() {
        appSettings = AppSettings(environment: .Default)
        
        let buildEnv = appSettings.buildEnvironment
        
        XCTAssertEqual(buildEnv, "dev")
    }
    
    func testItReturnsBuildNumber() {
        appSettings = AppSettings(environment: .Default)
        
        let buildEnv = appSettings.buildNumber
        
        XCTAssertEqual(buildEnv, "1.3.5")
    }
}
