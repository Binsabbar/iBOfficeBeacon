//
//  AppUpdateControllerUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class AppUpdateControllerUnitTest: XCTestCase {

    var subject: AppUpdateController!
    var spyManager: UpdateManagerSpy!
    var fakeSettings: FakeAppSettings!
    
    override func setUp() {
        super.setUp()
        spyManager = UpdateManagerSpy()
        fakeSettings = FakeAppSettings(environment: .Default)
        fakeSettings.setFeautreToggle(.HockeyAppIntegration, To: true)
        subject = AppUpdateController(updateManager: spyManager, settings: fakeSettings)
        UserDefaults.standard.removeObject(forKey: "AppUpdateCheckDate")
    }

    func testItCallsCheckForUpdateWhenHockeyAppIntegrationIsEnabled() {
        subject.performUpdateCheckInBackground()

        waitForBackgroundTask() { _ in
            XCTAssertTrue(self.spyManager.checkForUpdateCalled)
        }
    }
    
    func testItDoesNotCallCheckForUpdateWhenHockeyAppIntegrationIsNotEnabled() {
        fakeSettings.setFeautreToggle(.HockeyAppIntegration, To: false)
        subject = AppUpdateController(updateManager: spyManager, settings: fakeSettings)
        
        subject.performUpdateCheckInBackground()
        
        waitForBackgroundTask() { _ in
            XCTAssertFalse(self.spyManager.checkForUpdateCalled)
        }
    }
    
    func testItRegisterUpdateDateInUserSettings() {
        subject.performUpdateCheckInBackground()
        
        waitForBackgroundTask() { _ in
            let updateDate = UserDefaults.standard.object(forKey: "AppUpdateCheckDate")
            XCTAssertTrue((updateDate as! Date).compareDateToDayPrecision(Date()) == .orderedSame)
        }
    }
    
    func testItDoesNotCheckForUpdateTwiceForTheSameDay() {
        subject.performUpdateCheckInBackground()
        
        waitForBackgroundTask() { _ in
            XCTAssertTrue(self.spyManager.checkForUpdateCalled)
            
            self.spyManager.checkForUpdateCalled=false
            
            self.subject.performUpdateCheckInBackground()
            self.waitForBackgroundTask() { _ in
                XCTAssertFalse(self.spyManager.checkForUpdateCalled)
            }
        }
    }
    
    func testItDoesNotCheckForUpdateIfItHasAlreadyCheckedToday() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "AppUpdateCheckDate")
        
        subject.performUpdateCheckInBackground()
        
        waitForBackgroundTask() { _ in
            XCTAssertFalse(self.spyManager.checkForUpdateCalled)
        }
    }
    
    func testItChecksForUpdateIfLastCheckedIsMoreThanOneDayAgo() {
        let defaults = UserDefaults.standard
        defaults.set(Date().addingTimeInterval(oneDay*(-1)), forKey: "AppUpdateCheckDate")
        
        subject.performUpdateCheckInBackground()
        
        waitForBackgroundTask() { _ in
            XCTAssertTrue(self.spyManager.checkForUpdateCalled)
        }
    }
    
    fileprivate func waitForBackgroundTask(_ handler: @escaping XCWaitCompletionHandler) {
        fullfillExpectation(expectation(description: "BackgroundCheck"),
                            withinTime: hundredMs * 2)
        self.waitForExpectations(timeout: hundredMs * 3, handler: handler)
    }
}
