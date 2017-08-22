//
//  NavigationControllerBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/10/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class NavigationControllerBuilder {
    
    fileprivate var navigationVC: NavigationControllerSpy!
    
    init() {
        navigationVC = NavigationControllerSpy()
    }
    
    fileprivate init(navigationVC: NavigationControllerSpy) {
        self.navigationVC = navigationVC
    }
    
    func build() -> NavigationControllerSpy {
        UIApplication.shared.windows.first?.rootViewController = navigationVC
        return navigationVC
    }
    
    func pushViewController(_ viewController: UIViewController) -> NavigationControllerBuilder {
        navigationVC.viewControllers.append(viewController)
        return NavigationControllerBuilder(navigationVC: navigationVC)
    }
}
