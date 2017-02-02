//
//  MainViewController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, TWBeaconServiceProtocol, TWBeaconEventDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    let wiring = Wiring.sharedWiring
    let roomViewControllerSegueIdentifier = "showRoomView"
    
    var beaconService: TWBeaconService!
    var authController: AuthController!
    var errorAlertController: ErrorAlertController!
    
    var officeRoom: OfficeRoom?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        do {
            try beaconService.startRanging()
        } catch {
            let action = UIAlertAction(title: "Exit the app", style: .Destructive)
            { _ in exit(-1) }
            let message = "Internal unrecoverable error occured. Please report this issue."
            let alert = UIAlertController(title: "Fatel Error", message: message, preferredStyle: .Alert)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authController = wiring.authorizationController()
        errorAlertController = wiring.errorAlertController()
        errorAlertController.registerForNotifications()
        
        wiring.appUpdateController().performUpdateCheckInBackground()
        
        beaconService = wiring.beaconService()
        wiring.beaconManager().setBeaconTransitionEventsHandler(self)
        beaconService.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == roomViewControllerSegueIdentifier {
            let destinationViewController = segue.destinationViewController as! RoomScheduleViewController
            destinationViewController.officeRoom = officeRoom
        }
    }
    
    //MARK: - TWBeaconServiceProtocol
    var performeRoomViewDismiss = true
    func foundRoom(room: OfficeRoom) {
        NSThread.synchronize(performeRoomViewDismiss) {
            self.performeRoomViewDismiss = false
        }
        
        let roomView = presentedViewController as? RoomScheduleViewController
        if roomView == nil {
            officeRoom = room
            self.performSegueWithIdentifier(roomViewControllerSegueIdentifier, sender: self)
        } else if let currentRoom = officeRoom where currentRoom.isEqualTo(room) {
                roomView?.checkRoomStatus()
        } else {
            officeRoom = room
            dismissViewControllerAnimated(false){
                self.performSegueWithIdentifier(self.roomViewControllerSegueIdentifier, sender: self)
            }
        }
    }
    
    func movedAwayFromClosestBeacon() {
        NSThread.synchronize(performeRoomViewDismiss) {
            self.performeRoomViewDismiss = true
        }
        
        NSThread.excuteAfterDelay(2) {
            NSThread.synchronize(self.performeRoomViewDismiss) {
                if (self.performeRoomViewDismiss) {
                    self.dismissViewControllerAnimated(false){}
                }
            }
        }
    }
}
