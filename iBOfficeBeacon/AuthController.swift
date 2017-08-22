//
//  IntroViewController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

protocol AuthControlerProtocol {
    func authenticationFinishedWithResult(_ result: AuthResult)
}

enum AuthResult: Int {
    case succeed = 1
    case failed = 2
}

class AuthController: NSObject {
    
    var authDelegate:AuthControlerProtocol?
    
    fileprivate let services: Array<GTLRService>
    fileprivate let settings: GoogleSettings
    fileprivate var auth: GTMOAuth2Authentication!
    
    init(services: [GTLRService], withSettings settings: GoogleSettings) {
        self.services = services
        self.settings = settings
        self.auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: settings.keychainItemName,
            clientID: settings.clientID,
            clientSecret: nil)
        super.init()        
    }
    
    func canAuthorize() -> Bool {
        if let authorizer = auth, authorizer.canAuthorize {
            for service in services {
                service.authorizer = authorizer
            }
            return true
        }
        return false
    }
    
    func logout() {
        GTMOAuth2ViewControllerTouch.revokeToken(forGoogleAuthentication: auth)
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychain(forName: settings.keychainItemName)
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
    func viewController(_ viewController: UIViewController, finishedWithAuth result: GTMOAuth2Authentication,
                        error : NSError?) {
        
        var authResult: AuthResult = .succeed
        var alert: UIAlertController?
        auth = result
        
        if let error = error {
            authResult = .failed
            auth = nil
            alert = showAlert("Authentication Error", message: error.localizedDescription)
        }
        
        for service in services {
            service.authorizer = auth
        }
        
        viewController.presentingViewController?.dismiss(animated: true, completion: { _ in
            if let alert = alert {
                viewController.presentingViewController?.present(alert, animated: true, completion: nil)
            }
            self.authDelegate?.authenticationFinishedWithResult(authResult)
        })
    }
    
    //MARK: Helpers
    fileprivate func showAlert(_ title : String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
}
