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
        NSUserDefaults.standardUserDefaults().removeObjectForKey("AppUpdateCheckDate")
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
            let updateDate = NSUserDefaults.standardUserDefaults().objectForKey("AppUpdateCheckDate")
            XCTAssertTrue((updateDate as! NSDate).compareDateToDayPrecision(NSDate()) == .OrderedSame)
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
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSDate(), forKey: "AppUpdateCheckDate")
        
        subject.performUpdateCheckInBackground()
        
        waitForBackgroundTask() { _ in
            XCTAssertFalse(self.spyManager.checkForUpdateCalled)
        }
    }
    
    func testItChecksForUpdateIfLastCheckedIsMoreThanOneDayAgo() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSDate().dateByAddingTimeInterval(oneDay*(-1)), forKey: "AppUpdateCheckDate")
        
        subject.performUpdateCheckInBackground()
        
        waitForBackgroundTask() { _ in
            XCTAssertTrue(self.spyManager.checkForUpdateCalled)
        }
    }
    
    private func waitForBackgroundTask(handler: XCWaitCompletionHandler) {
        fullfillExpectation(expectationWithDescription("BackgroundCheck"),
                            withinTime: hundredMs * 2)
        self.waitForExpectationsWithTimeout(hundredMs * 3, handler: handler)
    }
}
