//
//  LogoutControllerUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class LogoutControllerUnitTest: XCTestCase {
    
    var authControllerSpy: AuthControllerSpy!
    var fileServiceSpy: FileServiceSpy!
    var controller: LogoutController!
    
    override func setUp() {
        super.setUp()
        authControllerSpy = AuthControllerSpy()
        fileServiceSpy = FileServiceSpy()
        controller = LogoutController(authController: authControllerSpy, fileService: fileServiceSpy)
    }
    
    func testItRemovesItemsFromKeychain() {
        controller.logout()
        
        XCTAssertTrue(authControllerSpy.isLogoutCalled)
    }
    
    
    func testItRemovesBeaconAddressFile() {
        controller.logout()
        
        XCTAssertEqual(fileServiceSpy.deleteFileParam!, AppSettings.LOCAL_BEACON_ADDRESS_FILE_NAME)
        XCTAssertTrue(fileServiceSpy.isDeleteFileCalled)
    }
}
