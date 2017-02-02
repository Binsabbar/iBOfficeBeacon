//
//  ErrorHandlerAlert.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 15/06/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class ErrorAlertController {
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var isAlertBeingPresented = false
    var currentNotification: NSNotification?
    
    @objc func loadingBeaconAddressFailed(notification: NSNotification) {
        if notification.name != currentNotification?.name && !isAlertBeingPresented {
            currentNotification = notification
            showDismissableAlertWithTitle("Error", message: "Error occured while loading office addresses. Please contact your admin. Sorry for the inconvenience caused")
        }
    }
    
    @objc func userIsNotAuthorised(notification: NSNotification) {
        if notification.name != currentNotification?.name && !isAlertBeingPresented {
            currentNotification = notification
            showDismissableAlertWithTitle("User Logged out", message: "Have you changed your password recently? Please login again.")
        }
    }
    
    func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ErrorAlertController.loadingBeaconAddressFailed), name: BeaconAddressLoader.ParsingAddressFailed, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ErrorAlertController.userIsNotAuthorised),
                                                         name: GoogleAuthorizationErrorHandler.UserIsNotAuthenticatedNotification, object: nil)
    }
    
    
    private func showDismissableAlertWithTitle(title: String, message: String) {
        self.isAlertBeingPresented = true
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(alertAction)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: {})
    }
    
    private var alertAction: UIAlertAction {
        return UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
            self.isAlertBeingPresented = false
            self.currentNotification = nil
        })
    }
}
