//
//  IntroViewController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

protocol AuthControlerProtocol {
    func authenticationFinishedWithResult(result: AuthResult)
}

enum AuthResult: Int {
    case Succeed = 1
    case Failed = 2
}

class AuthController: NSObject {
    
    var authDelegate:AuthControlerProtocol?
    
    private let services: Array<GTLRService>
    private let settings: GoogleSettings
    private var auth: GTMOAuth2Authentication!
    
    init(services: [GTLRService], withSettings settings: GoogleSettings) {
        self.services = services
        self.settings = settings
        self.auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            settings.keychainItemName,
            clientID: settings.clientID,
            clientSecret: nil)
        super.init()        
    }
    
    func canAuthorize() -> Bool {
        if let authorizer = auth where authorizer.canAuthorize {
            for service in services {
                service.authorizer = authorizer
            }
            return true
        }
        return false
    }
    
    func logout() {
        GTMOAuth2ViewControllerTouch.revokeTokenForGoogleAuthentication(auth)
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychainForName(settings.keychainItemName)
    }
    
    func authorizationView() -> GTMOAuth2ViewControllerTouch {
        return GTMOAuth2ViewControllerTouch(scope: settings.scopes,
            clientID: settings.clientID, clientSecret: nil,
            keychainItemName: settings.keychainItemName,
            delegate: self, finishedSelector:
                #selector(AuthController.viewController(_:finishedWithAuth:error:))
        )
    }
    
    //MARK: Auth Callback
    func viewController(viewController: UIViewController, finishedWithAuth result: GTMOAuth2Authentication,
                        error : NSError?) {
        
        var authResult: AuthResult = .Succeed
        var alert: UIAlertController?
        auth = result
        
        if let error = error {
            authResult = .Failed
            auth = nil
            alert = showAlert("Authentication Error", message: error.localizedDescription)
        }
        
        for service in services {
            service.authorizer = auth
        }
        
        viewController.presentingViewController?.dismissViewControllerAnimated(true, completion: { _ in
            if let alert = alert {
                viewController.presentingViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            self.authDelegate?.authenticationFinishedWithResult(authResult)
        })
    }
    
    //MARK: Helpers
    private func showAlert(title : String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
}
