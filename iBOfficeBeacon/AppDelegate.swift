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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.setupHockyApp()
        self.assignBeaconManagerForLaunchOptions(launchOptions)
        self.initRootViewController()
        return true
    }

    fileprivate func initRootViewController() {
        if(wiring.authorizationController().canAuthorize()) {
            let storyboardName = "MainV1"
            let entryViewName = "mainViewV1"
            
            let storyboard = UIStoryboard.init(name: storyboardName, bundle: Bundle.main)
            
            if let nv = window?.rootViewController as? UINavigationController {
                let viewC = storyboard.instantiateViewController(withIdentifier: entryViewName)
                nv.pushViewController(viewC, animated: false)
            }
        }
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.assignBeaconManagerForInactiveState()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.assignBeaconManagerForActiveState()
        wiring.beaconAddressStore().refreshAdddresses()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        wiring.locationServiceAuthzController().checkLocationAuthorizationStatus()
        wiring.bluetoothController()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
}

