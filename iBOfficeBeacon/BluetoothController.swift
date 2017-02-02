//
//  BluetoothController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 08/06/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class BluetoothController: NSObject, CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .PoweredOff:
            let alert = UIAlertController(title: "Bluetooth Off", message: alertMessage, preferredStyle: .Alert)
            alert.addAction(alertAction)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    private var alertMessage: String {
        return "Bluetooth is off. In order to use the app, please turn it on in the Settings or from Control Center by swiping up from the bottom edge of the screen."
    }
    
    private var alertAction: UIAlertAction {
        return UIAlertAction(title: "OK", style: .Default, handler: nil)
    }
    
}
