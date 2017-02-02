//
//  LocationServiceAuthzControllerUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class LocationServiceAuthzControllerUnitTest: XCTestCase {

    var subject: LocationServiceAuthzController!
    
    var fakeManager: FakeESTBeaconManager!
    var viewControllerSpy: ViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        fakeManager = FakeESTBeaconManager()
        viewControllerSpy = ViewControllerSpy()
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewControllerSpy
        
        subject = LocationServiceAuthzController(locationClass: CLLocationManagerStub.self, manager: fakeManager)
    }
    
    func testItShowsAlertWhenAuthzStatusIsDenied() {
        CLLocationManagerStub.setStatus(.Denied)
   
        subject.checkLocationAuthorizationStatus()
        
        XCTAssertTrue(viewControllerSpy.presentViewControllerIsCalled)
        XCTAssertFalse(fakeManager.requestWhenInUseAuthorizationIsCalled)
    }
    
    func testItShowsAlertWhenAuthzStatusIsRestricted() {
        CLLocationManagerStub.setStatus(.Restricted)
        
        subject.checkLocationAuthorizationStatus()
        
        XCTAssertTrue(viewControllerSpy.presentViewControllerIsCalled)
        XCTAssertFalse(fakeManager.requestWhenInUseAuthorizationIsCalled)
    }
    
    func testItRequestAuthzWhenAuthzStatusIsNotDetermined() {
        CLLocationManagerStub.setStatus(.NotDetermined)
        
        subject.checkLocationAuthorizationStatus()
        
        XCTAssertTrue(fakeManager.requestWhenInUseAuthorizationIsCalled)
        XCTAssertFalse(viewControllerSpy.presentViewControllerIsCalled)
    }
    
    func testItDoesNotShowsAlertWhenAuthzStatusIsAuthorizedWhenInUse() {
        CLLocationManagerStub.setStatus(.AuthorizedWhenInUse)
        
        subject.checkLocationAuthorizationStatus()
        
        XCTAssertFalse(viewControllerSpy.presentViewControllerIsCalled)
    }
}
