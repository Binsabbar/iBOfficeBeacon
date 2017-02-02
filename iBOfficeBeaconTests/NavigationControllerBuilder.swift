//
//  NavigationControllerBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/10/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class NavigationControllerBuilder {
    
    private var navigationVC: NavigationControllerSpy!
    
    init() {
        navigationVC = NavigationControllerSpy()
    }
    
    private init(navigationVC: NavigationControllerSpy) {
        self.navigationVC = navigationVC
    }
    
    func build() -> NavigationControllerSpy {
        UIApplication.sharedApplication().windows.first?.rootViewController = navigationVC
        return navigationVC
    }
    
    func pushViewController(viewController: UIViewController) -> NavigationControllerBuilder {
        navigationVC.viewControllers.append(viewController)
        return NavigationControllerBuilder(navigationVC: navigationVC)
    }
}
