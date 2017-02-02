//
//  GoogleAuthorizationErrorHandler.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 31/08/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class GoogleAuthorizationErrorHandler: ErrorHandlingProtocol {
    
    static var UserIsNotAuthenticatedNotification = "UserIsNotAuthenticated"
    private let authController: AuthController
    private let unauthorisedErrorCode = 403
    private let settings: AppSettings
    
    init (authController: AuthController) {
        self.authController = authController
        self.settings = Wiring.sharedWiring.settings()
    }
    
    func handleError(error: NSError) {
        if error.code == unauthorisedErrorCode {
            if settings.environment == AppEnvironment.Dev
            && error.description.containsString("Forbidden") {
                return
            }
            authController.logout()
            let nv = UIApplication.sharedApplication().windows.first?.rootViewController as! UINavigationController
            nv.popToRootViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName(GoogleAuthorizationErrorHandler.UserIsNotAuthenticatedNotification, object: nil)
        }
    }
}
