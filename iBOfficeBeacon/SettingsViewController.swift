//
//  SettingsViewController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 10/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIBlurredBorderedButton!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var sendFeedbackButton: UIBlurredBorderedButton!
    @IBOutlet weak var logoutButtonTopConstraint: NSLayoutConstraint!
    
    var settings: AppSettings!
    let topSpaceFromLayout: CGFloat = 20
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtonColor()
        settings = Wiring.sharedWiring.settings()
        let currentEnv = settings.environment
        self.setupBackgroundImage()
        self.navigationController?.navigationBar.tintColor = AppColours.lightGrey
        
        if (currentEnv == .Test || currentEnv == .Dev ) {
            self.buildLabel.isHidden = false
            self.buildLabel.text = "Beta version: \(settings.buildNumber)"
        }
        
        let featureName = FeatureToggles.HockeyAppIntegration.rawValue
        if let hockeyAppEnabled = settings.featureToggles[featureName], !hockeyAppEnabled {
            sendFeedbackButton.isHidden = true
            moveLogoutButtonPositionToFeedbackButtonPosition()
            view.setNeedsLayout()
        }
    }
    
    @IBAction func logoutUser(_ sender: AnyObject) {
        Wiring.sharedWiring.logoutController().logout()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func showFeedbackView(_ sender: AnyObject) {
        let feedbackManager = BITHockeyManager.shared().feedbackManager
        feedbackManager.feedbackComposeHideImageAttachmentButton = true
        feedbackManager.showAlertOnIncomingMessages = false
        feedbackManager.requireUserName = .required
        feedbackManager.requireUserEmail = .optional
        feedbackManager.showFeedbackListView()
    }
    
    fileprivate func moveLogoutButtonPositionToFeedbackButtonPosition() {
        let topConstraint = logoutButtonTopConstraint.constant
        logoutButtonTopConstraint.constant = -(topConstraint + topSpaceFromLayout)
    }
    
    fileprivate func setupButtonColor() {
        logoutButton.colorForNormalState = UIColor.clear
        logoutButton.colorForTapState = AppColours.darkestGrey
    }
    
    fileprivate func setupBackgroundImage() {
        let blur = UIBlurEffect(style: .dark)
        
        let vibrancy = UIVibrancyEffect(blurEffect: blur)
        let vibrantEffect = UIVisualEffectView(effect: vibrancy)
        let visualEffect = UIVisualEffectView(effect: blur)
        vibrantEffect.frame = self.view.frame
        visualEffect.frame = self.view.frame
    }
    
}
