//
//  LoginViewController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 08/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//


class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var loginButton: UIBlurredBorderedButton!
    @IBOutlet weak var label: UILabel!
    
    let googleAuth = Wiring.sharedWiring.googleAuthorizationController()
    
    let loginPromptText = "Use your work email to login \nto access room information"
    
    var wiring:Wiring!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        wiring.appUpdateController().performUpdateCheckInBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonColor()
        setupLabel()
        wiring = Wiring.sharedWiring
    }
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        googleAuth.startSignInProcess(uidelegate: self, callback: signInCallback)
    }
    
    fileprivate func signInCallback(_ result: AuthResult) {
        if result == .succeed {
            self.performSegue(withIdentifier: "showMainView", sender: self)
        } else {
            present(showAlert("Error loging in", message: "There was an error while trying to logging you in"),
                    animated: true)
        }
    }
    

    //MARK: UI Setup
    fileprivate func setupButtonColor() {
        loginButton.colorForNormalState = UIColor.clear
        loginButton.colorForTapState = AppColours.darkestGrey
    }
    
    fileprivate func setupLabel() {
        label.text = loginPromptText
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = AppColours.lightGrey
        label.font = UIFont.systemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
    }
    
    //MARK: Helpers
    fileprivate func showAlert(_ title : String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
}
