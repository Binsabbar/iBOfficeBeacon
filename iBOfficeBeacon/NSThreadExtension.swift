//
//  NSThreadExtension.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

extension NSThread {
    
    class func excuteAfterDelay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    class func synchronize(lockObj: AnyObject!, closure: ()->()){
        objc_sync_enter(lockObj)
        closure()
        objc_sync_exit(lockObj)
    }
}
