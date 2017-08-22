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
        NotificationCenter.default.removeObserver(self)
    }
    
    var isAlertBeingPresented = false
    var currentNotification: Notification?
    
    @objc func loadingBeaconAddressFailed(_ notification: Notification) {
        if notification.name != currentNotification?.name && !isAlertBeingPresented {
            currentNotification = notification
            showDismissableAlertWithTitle("Error", message: "Error occured while loading office addresses. Please contact your admin. Sorry for the inconvenience caused")
        }
    }
    
    @objc func userIsNotAuthorised(_ notification: Notification) {
        if notification.name != currentNotification?.name && !isAlertBeingPresented {
            currentNotification = notification
            showDismissableAlertWithTitle("User Logged out", message: "Have you changed your password recently? Please login again.")
        }
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ErrorAlertController.loadingBeaconAddressFailed), name: NSNotification.Name(rawValue: BeaconAddressLoader.ParsingAddressFailed), object: nil)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(ErrorAlertController.userIsNotAuthorised),
                                                         name: NSNotification.Name(rawValue: GoogleAuthorizationErrorHandler.UserIsNotAuthenticatedNotification), object: nil)
    }
    
    
    fileprivate func showDismissableAlertWithTitle(_ title: String, message: String) {
        self.isAlertBeingPresented = true
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {})
    }
    
    fileprivate var alertAction: UIAlertAction {
        return UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            self.isAlertBeingPresented = false
            self.currentNotification = nil
        })
    }
}
