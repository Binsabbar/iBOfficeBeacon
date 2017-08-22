//
//  LoginViewController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 08/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//


class LoginViewController: UIViewController, AuthControlerProtocol {

    @IBOutlet weak var loginButton: UIBlurredBorderedButton!
    @IBOutlet weak var label: UILabel!
    
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
        wiring.authorizationController().authDelegate = self
    }
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        let view = wiring.authorizationController().authorizationView()
        self.present(view, animated: true, completion: nil)
    }
    
    func authenticationFinishedWithResult(_ result: AuthResult) {
        if result == .succeed {
            self.performSegue(withIdentifier: "showMainView", sender: self)
        }
    }
    
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
}
