//
//  ErrorHandlerAlertUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/06/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class ErrorHandlerAlertUnitTest: XCTestCase {

    var subject: ErrorAlertController!
    
    override func setUp() {
        subject = ErrorAlertController()
        subject.registerForNotifications()
    }
    
    func testItDisplaysAlertMessageWhenParsingAddressFailedNotificationIsFired() {
        let viewControllerSpy = ViewControllerSpy()
        UIApplication.shared.keyWindow?.rootViewController = viewControllerSpy

        NotificationCenter.default.post(name: Notification.Name(rawValue: BeaconAddressLoader.ParsingAddressFailed), object: nil)
        let alertView = viewControllerSpy.presentedAlertController
        
        XCTAssertTrue(alertView?.title == "Error")
        XCTAssertTrue(alertView?.message == "Error occured while loading office addresses. Please contact your admin. Sorry for the inconvenience caused")
    }
    
    func testItDisplaysAlertMessageWhenUserIsNotAuthenticatedNotificationIsFired() {
        let viewControllerSpy = ViewControllerSpy()
        UIApplication.shared.keyWindow?.rootViewController = viewControllerSpy
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: GoogleAuthorizationErrorHandler.UserIsNotAuthenticatedNotification), object: nil)
        
        let alertView = viewControllerSpy.presentedAlertController
        
        XCTAssertTrue(alertView?.title == "User Logged out")
        XCTAssertTrue(alertView?.message == "Have you changed your password recently? Please login again.")
    }
    
}
