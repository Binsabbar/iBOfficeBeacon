//
//  AppDelegate.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 16/05/2015.
//  Copyright (c) 2015 Binsabbar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let wiring = Wiring.sharedWiring
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.setupHockyApp()
        self.assignBeaconManagerForLaunchOptions(launchOptions)
        self.initRootViewController()
        return true
    }

    private func initRootViewController() {
        if(wiring.authorizationController().canAuthorize()) {
            let storyboardName = "MainV1"
            let entryViewName = "mainViewV1"
            
            let storyboard = UIStoryboard.init(name: storyboardName, bundle: NSBundle.mainBundle())
            
            if let nv = window?.rootViewController as? UINavigationController {
                let viewC = storyboard.instantiateViewControllerWithIdentifier(entryViewName)
                nv.pushViewController(viewC, animated: false)
            }
        }
    }

    
    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.assignBeaconManagerForInactiveState()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        self.assignBeaconManagerForActiveState()
        wiring.beaconAddressStore().refreshAdddresses()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        wiring.locationServiceAuthzController().checkLocationAuthorizationStatus()
        wiring.bluetoothController()
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }
    
}

