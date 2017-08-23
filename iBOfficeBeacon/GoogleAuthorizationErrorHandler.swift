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
    fileprivate let authController: GoogleAuthController
    fileprivate let unauthorisedErrorCode = 403
    fileprivate let settings: AppSettings
    
    init (authController: GoogleAuthController) {
        self.authController = authController
        self.settings = Wiring.sharedWiring.settings()
    }
    
    func handleError(_ error: NSError) {
        if error.code == unauthorisedErrorCode {
            if settings.environment == AppEnvironment.Dev
            && error.description.contains("Forbidden") {
                return
            }
            authController.logout()
            let nv = UIApplication.shared.windows.first?.rootViewController as! UINavigationController
            nv.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: GoogleAuthorizationErrorHandler.UserIsNotAuthenticatedNotification), object: nil)
        }
    }
}
