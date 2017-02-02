//
//  ViewControllerSpy.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 08/06/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class ViewControllerSpy: UIViewController {
    
    var presentViewControllerIsCalled = false
    
    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        presentViewControllerIsCalled = true
        lastPresentedViewController = viewControllerToPresent
    }
    
    private(set) var lastPresentedViewController: UIViewController?
    
    var presentedAlertController:UIAlertController? {
        get {
            return lastPresentedViewController as? UIAlertController
        }
    }
}
