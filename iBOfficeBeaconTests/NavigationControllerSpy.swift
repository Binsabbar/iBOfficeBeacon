//
//  NavigationControllerSpy.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 09/10/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class NavigationControllerSpy: UINavigationController {
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        if(viewControllers.count > 0) {
            self.viewControllers.removeLast()
        }
        return self.viewControllers
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        return self.viewControllers.removeLast()
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
    }
    
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        for view in viewControllers {
            if view == viewController {
                return self.viewControllers
            }
            self.viewControllers.popLast()
        }
        return self.viewControllers
    }
}
