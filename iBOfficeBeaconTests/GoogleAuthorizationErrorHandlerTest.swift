//
//  GoogleAuthorizationErrorHandlerTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 29/08/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class GoogleAuthorizationErrorHandlerTest: XCTestCase {

    var authController = AuthControllerSpy()
    
    var subject: GoogleAuthorizationErrorHandler!
    var isUserIsNotAuthenticatedNotificationFired = false
    
    override func setUp() {
        super.setUp()
        isUserIsNotAuthenticatedNotificationFired = false
        subject = GoogleAuthorizationErrorHandler(authController: authController)
    }
    
    func testItLogsUserOutFor4XXErrors() {
        let error = NSErrorBuilder.createUnauthenticatedUseExceededError()
        
        subject.handleError(error)

        XCTAssertTrue(authController.isLogoutCalled)
    }

    func testItDoesNotLogUserOutForOther4XXNon403Errors() {
        let error = NSErrorBuilder.createNSErrorWithCode(400)
        let rootViewControllerSpy = ViewControllerSpy()
        let secondViewController = ViewControllerSpy()
        let nvcSpy = NavigationControllerBuilder().pushViewController(rootViewControllerSpy)
            .pushViewController(secondViewController)
            .build()
        
        subject.handleError(error)
        
        XCTAssertFalse(authController.isLogoutCalled)
        XCTAssertTrue(nvcSpy.viewControllers.count == 2)
        XCTAssertTrue(nvcSpy.visibleViewController == secondViewController)
    }
    
    func testItDoesNotLogUserOutForOtherNon4XXErrors() {
        let error = NSErrorBuilder.createNSErrorWithCode(502)
        let rootViewControllerSpy = ViewControllerSpy()
        let secondViewController = ViewControllerSpy()
        let nvcSpy = NavigationControllerBuilder().pushViewController(rootViewControllerSpy)
            .pushViewController(secondViewController)
            .build()
        
        subject.handleError(error)
        
        XCTAssertFalse(authController.isLogoutCalled)
        XCTAssertTrue(nvcSpy.viewControllers.count == 2)
        XCTAssertTrue(nvcSpy.visibleViewController == secondViewController)
    }
    
    func testItPopsToLoginViewControllerFor403Error() {
        let error = NSErrorBuilder.createUnauthenticatedUseExceededError()
        let rootViewControllerSpy = ViewControllerSpy()
        let nvcSpy = NavigationControllerBuilder().pushViewController(rootViewControllerSpy)
            .pushViewController(ViewControllerSpy())
            .build()
        
        subject.handleError(error)

        XCTAssertTrue(authController.isLogoutCalled)
        XCTAssertTrue(nvcSpy.viewControllers.count == 1)
        XCTAssertTrue(nvcSpy.visibleViewController == rootViewControllerSpy)
    }
    
    func testItFiresUserIsNotAuthenticatedNotificationFor403Errors() {
        let error = NSErrorBuilder.createUnauthenticatedUseExceededError()
        let rootViewControllerSpy = ViewControllerSpy()
        NavigationControllerBuilder().pushViewController(rootViewControllerSpy)
            .pushViewController(ViewControllerSpy())
            .build()
        
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: #selector(GoogleAuthorizationErrorHandlerTest.userIsNotAuthenticatedNotification), name: GoogleAuthorizationErrorHandler.UserIsNotAuthenticatedNotification, object: nil)

        subject.handleError(error)
        
        XCTAssertTrue(isUserIsNotAuthenticatedNotificationFired)
    }
    
    @objc func userIsNotAuthenticatedNotification() {
        isUserIsNotAuthenticatedNotificationFired = true
    }
}
