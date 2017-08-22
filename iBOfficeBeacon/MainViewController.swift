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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        do {
            try beaconService.startRanging()
        } catch {
            let action = UIAlertAction(title: "Exit the app", style: .destructive)
            { _ in exit(-1) }
            let message = "Internal unrecoverable error occured. Please report this issue."
            let alert = UIAlertController(title: "Fatel Error", message: message, preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == roomViewControllerSegueIdentifier {
            let destinationViewController = segue.destination as! RoomScheduleViewController
            destinationViewController.officeRoom = officeRoom
        }
    }
    
    //MARK: - TWBeaconServiceProtocol
    var performeRoomViewDismiss = true
    func foundRoom(_ room: OfficeRoom) {
        
        Thread.synchronize(performeRoomViewDismiss as AnyObject) {
            self.performeRoomViewDismiss = false
        }
        
        let roomView = presentedViewController as? RoomScheduleViewController
        if roomView == nil {
            officeRoom = room
            self.performSegue(withIdentifier: roomViewControllerSegueIdentifier, sender: self)
        } else if let currentRoom = officeRoom, currentRoom.isEqualTo(room) {
                roomView?.checkRoomStatus()
        } else {
            officeRoom = room
            dismiss(animated: false){
                self.performSegue(withIdentifier: self.roomViewControllerSegueIdentifier, sender: self)
            }
        }
    }
    
    func movedAwayFromClosestBeacon() {
        Thread.synchronize(performeRoomViewDismiss as AnyObject) {
            self.performeRoomViewDismiss = true
        }
        
        Thread.excuteAfterDelay(2) {
            Thread.synchronize(self.performeRoomViewDismiss as AnyObject) {
                if (self.performeRoomViewDismiss) {
                    self.dismiss(animated: false){}
                }
            }
        }
    }
}
