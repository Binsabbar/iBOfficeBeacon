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
    
    override func viewWillAppear(animated: Bool) {
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
            self.buildLabel.hidden = false
            self.buildLabel.text = "Beta version: \(settings.buildNumber)"
        }
        
        let featureName = FeatureToggles.HockeyAppIntegration.rawValue
        if let hockeyAppEnabled = settings.featureToggles[featureName]
            where !hockeyAppEnabled {
            sendFeedbackButton.hidden = true
            moveLogoutButtonPositionToFeedbackButtonPosition()
            view.setNeedsLayout()
        }
    }
    
    @IBAction func logoutUser(sender: AnyObject) {
        Wiring.sharedWiring.logoutController().logout()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func showFeedbackView(sender: AnyObject) {
        let feedbackManager = BITHockeyManager.sharedHockeyManager().feedbackManager
        feedbackManager.feedbackComposeHideImageAttachmentButton = true
        feedbackManager.showAlertOnIncomingMessages = false
        feedbackManager.requireUserName = .Required
        feedbackManager.requireUserEmail = .Optional
        feedbackManager.showFeedbackListView()
    }
    
    private func moveLogoutButtonPositionToFeedbackButtonPosition() {
        let topConstraint = logoutButtonTopConstraint.constant
        logoutButtonTopConstraint.constant = -(topConstraint + topSpaceFromLayout)
    }
    
    private func setupButtonColor() {
        logoutButton.colorForNormalState = UIColor.clearColor()
        logoutButton.colorForTapState = AppColours.darkestGrey
    }
    
    private func setupBackgroundImage() {
        let blur = UIBlurEffect(style: .Dark)
        
        let vibrancy = UIVibrancyEffect(forBlurEffect: blur)
        let vibrantEffect = UIVisualEffectView(effect: vibrancy)
        let visualEffect = UIVisualEffectView(effect: blur)
        vibrantEffect.frame = self.view.frame
        visualEffect.frame = self.view.frame
    }
    
}
