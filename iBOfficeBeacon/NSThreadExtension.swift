//
//  NSThreadExtension.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 25/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

extension Thread {
    
    class func excuteAfterDelay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    class func synchronize(_ lockObj: AnyObject!, closure: ()->()){
        objc_sync_enter(lockObj)
        closure()
        objc_sync_exit(lockObj)
    }
}
