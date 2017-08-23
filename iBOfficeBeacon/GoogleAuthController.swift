//
//  GoogleAuthController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 22/08/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

enum AuthResult {
    case succeed
    case failed
}

class GoogleAuthController: NSObject, GIDSignInDelegate{
    
    typealias AsycSignInCallback = (AuthResult) -> Void
    
    fileprivate let services: Array<GTLRService>
    fileprivate let settings: GoogleSettings
    fileprivate var canAuthCallback: AsycSignInCallback?
    fileprivate var signInCallback: AsycSignInCallback?
    
    init(services: [GTLRService], withSettings settings: GoogleSettings) {
        self.services = services
        self.settings = settings
        super.init()
        GIDSignIn.sharedInstance().scopes = settings._scopes
        GIDSignIn.sharedInstance().clientID = settings.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func trySignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func canAuthorizeAync(compeletion: @escaping AsycSignInCallback) {
        if(GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            canAuthCallback = compeletion
            GIDSignIn.sharedInstance().signInSilently()
        }
        compeletion(AuthResult.failed)
    }
    
    
    func logout() {
        GIDSignIn.sharedInstance().disconnect()
        GIDSignIn.sharedInstance().signOut()
    }
    
    func startSignInProcess(uidelegate: GIDSignInUIDelegate, callback: @escaping AsycSignInCallback) {
        signInCallback = callback
        GIDSignIn.sharedInstance().uiDelegate = uidelegate
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        var authResult: AuthResult = .failed
        var authorizer:GTMFetcherAuthorizationProtocol?
        
        if error == nil {
            authResult = .succeed
            authorizer = user.authentication.fetcherAuthorizer()
        }
        
        for service in services {
            service.authorizer = authorizer
        }
        
        signInCallback?(authResult)
        canAuthCallback?(authResult)
    }
}
