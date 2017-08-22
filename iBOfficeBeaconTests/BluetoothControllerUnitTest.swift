//
//  BluetoothControllerUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 08/06/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

@available(iOS 10.0, *)
class BluetoothControllerUnitTest: XCTestCase {

    var subject: BluetoothController!
    var manager: CBPeripheralManagerStub!
    var alertMessage = "Bluetooth is off. In order to use the app, please turn it on in the Settings or from Control Center by swiping up from the bottom edge of the screen."
    
    override func setUp() {
        super.setUp()
        subject = BluetoothController()
        manager = CBPeripheralManagerStub(delegate: subject, queue: nil, options: nil)
    }
    
    func testItDoesNotShowAlertIfStateIsOn() {
        let viewControllerSpy = ViewControllerSpy()
        UIApplication.shared.keyWindow?.rootViewController = viewControllerSpy
        
        manager.setCBPeripheralState(.poweredOn)
        
        subject.peripheralManagerDidUpdateState(manager)
        
        XCTAssertFalse(viewControllerSpy.presentViewControllerIsCalled)
    }

    func testItShowsAlertIfStateIsOff() {
        let viewControllerSpy = ViewControllerSpy()
        UIApplication.shared.keyWindow?.rootViewController = viewControllerSpy
        
        manager.setCBPeripheralState(.poweredOff)
        
        subject.peripheralManagerDidUpdateState(manager)
        
        XCTAssertTrue(viewControllerSpy.presentViewControllerIsCalled)
        XCTAssertTrue(viewControllerSpy.presentedAlertController?.title == "Bluetooth Off")
        XCTAssertTrue(viewControllerSpy.presentedAlertController?.message == alertMessage)
    }
    
}
