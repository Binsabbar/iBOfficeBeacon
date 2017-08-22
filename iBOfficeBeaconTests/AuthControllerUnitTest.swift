//
//  AuthController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

let AUTH_CONTROLLER_UT_KEYCHAIN_ITEM_NAME = "United Test Keychain Item Auth Controller"

class AuthControllerUnitTest: XCTestCase {

    var subject: AuthController!
    var settings: FakeGoogleSettings!
    let services  = [GTLRCalendarService(), GTLRDriveService()]
    
    override func setUp() {
        super.setUp()
        settings = FakeGoogleSettings(clientID: "random client ID")
        saveItemToKeychain()
        
        subject = AuthController(services: services, withSettings: settings)
    }
    
    override func tearDown() {
        removeItemFromKeychain()
        super.tearDown()
    }

    func testItReturnsTrueWhenAuthItemIsFoundInTheKeychain() {
        XCTAssertTrue(subject.canAuthorize())
    }
    
    func testItAssignsAuthToTheServiceIfAuthIsFoundInTheKeychain() {
        subject.canAuthorize()
        
        let authorizer = services.first!.authorizer as? GTMOAuth2Authentication
        
        XCTAssertTrue(authorizer?.refreshToken == auth.refreshToken)
        XCTAssertTrue(authorizer?.scope == auth.scope)
    }
    
    func testItReturnsFalseWhenNoAuthItemIsFoundInTheKeychain() {
        removeItemFromKeychain()
        subject = AuthController(services: services, withSettings: settings)
        
        XCTAssertFalse(subject.canAuthorize())
    }
    
    func testItRemovesAuthKeychainItemWhenLogout() {
        XCTAssertTrue(subject.canAuthorize())
        
        subject.logout()
        
        XCTAssertFalse(subject.canAuthorize())
    }
    
    func testItInitAuthViewControllerFromTheSettings() {
        let vc = subject.authorizationView()
        
        XCTAssertTrue(vc.authentication.clientID == settings.clientID)
        XCTAssertTrue(vc.keychainItemName == settings.keychainItemName)
        XCTAssertTrue(vc.authentication.scope == settings.scopes)
    }
    
    func testItSavesAuthResultToServiceAfterAuthorizationSucceeds() {
        subject.viewController(UIViewController(), finishedWithAuth: auth, error: nil)
        
        let authorizer = services.first!.authorizer as? GTMOAuth2Authentication
        
        XCTAssertTrue(authorizer?.accessToken == auth.accessToken)
        XCTAssertTrue(authorizer?.refreshToken == auth.refreshToken)
        XCTAssertTrue(authorizer?.scope == auth.scope)
    }
    
    //MARK: test helper methods
    fileprivate func removeItemFromKeychain() {
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychain(forName: settings.keychainItemName)
    }
    
    fileprivate func saveItemToKeychain() -> Bool {
        return GTMOAuth2ViewControllerTouch.saveParamsToKeychain(forName: settings.keychainItemName, authentication: auth)
    }
    
    fileprivate var auth: GTMOAuth2Authentication {
        get {
            let _auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
                forName: settings.keychainItemName,
                clientID: settings.clientID, clientSecret: nil)
            _auth?.accessToken = "Some Token"
            _auth?.refreshToken = "some other token"
            _auth?.scope = "some scope new"
            return _auth!
        }
    }
    
}
