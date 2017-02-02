//
//  LocationServiceAuthController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class LocationServiceAuthzController {
    
    let manager: ESTBeaconManager!
    let locationClass: CLLocationManager.Type
    
    init(locationClass: CLLocationManager.Type, manager: ESTBeaconManager){
        self.locationClass = locationClass
        self.manager = manager
    }
    
    convenience init(beaconManager: ESTBeaconManager) {
        self.init(locationClass: CLLocationManager.self, manager: beaconManager)
    }
    
    func checkLocationAuthorizationStatus() {
        switch locationClass.authorizationStatus() {
        case .Denied, .Restricted:
            let alert = UIAlertController(title: "Location Disabled", message: alertMessage, preferredStyle: .Alert)
            alert.addAction(alertAction)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            break
        case .NotDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default: break
        }
    }

    private var alertMessage: String {
        return "Location Service is disabled. In order to use the app, please enable it in the Settigs under Privacy, Location Services."
    }
    
    private var alertAction: UIAlertAction {
        return UIAlertAction(title: "Go to Settings now", style: .Default, handler: { action in
                UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
        })
    }
}
