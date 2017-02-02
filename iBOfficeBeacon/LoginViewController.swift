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
    
    override func viewWillAppear(animated: Bool) {
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
    
    @IBAction func loginTapped(sender: AnyObject) {
        let view = wiring.authorizationController().authorizationView()
        self.presentViewController(view, animated: true, completion: nil)
    }
    
    func authenticationFinishedWithResult(result: AuthResult) {
        if result == .Succeed {
            self.performSegueWithIdentifier("showMainView", sender: self)
        }
    }
    
    private func setupButtonColor() {
        loginButton.colorForNormalState = UIColor.clearColor()
        loginButton.colorForTapState = AppColours.darkestGrey
    }
    
    private func setupLabel() {
        label.text = loginPromptText
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 3
        label.textAlignment = .Center
        label.textColor = AppColours.lightGrey
        label.font = UIFont.systemFontOfSize(20)
        label.lineBreakMode = .ByWordWrapping
    }
}
