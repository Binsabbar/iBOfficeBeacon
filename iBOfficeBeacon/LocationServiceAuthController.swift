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
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Disabled", message: alertMessage, preferredStyle: .alert)
            alert.addAction(alertAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default: break
        }
    }

    fileprivate var alertMessage: String {
        return "Location Service is disabled. In order to use the app, please enable it in the Settigs under Privacy, Location Services."
    }
    
    fileprivate var alertAction: UIAlertAction {
        return UIAlertAction(title: "Go to Settings now", style: .default, handler: { action in
                UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
        })
    }
}
