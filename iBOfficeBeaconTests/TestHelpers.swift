//
//  TestHelpers.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 07/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
import XCTest

let hundredMs = NSTimeInterval(0.1)
let halfSecond = NSTimeInterval(0.5)
let second = NSTimeInterval(1)
let twoSeconds = NSTimeInterval(2)
let fiveSeconds = NSTimeInterval(5)

let oneDay = NSTimeInterval(86400)
let oneHour = NSTimeInterval(3600)
let halfAnHour = NSTimeInterval(1800)
let pastHour = NSTimeInterval(-3600)
let past2Hours = NSTimeInterval(-3600) * 2


func fullfillExpectation(expection:XCTestExpectation, withinTime seconds: NSTimeInterval) {
    let delay = seconds * Double(NSEC_PER_SEC)
    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    
    dispatch_after(dispatchTime, dispatch_get_main_queue()) { () -> Void in
        expection.fulfill()
    }
}

func compareDates(firstDate: NSDate, otherDate: NSDate) -> Bool {
    let result = NSCalendar.currentCalendar().compareDate(firstDate, toDate: otherDate,
                                                          toUnitGranularity: .Second)
    return result == .OrderedSame
}

func isString(firstString s1: String, equalsToOtherString s2: String, ignoreCase: Bool=true) -> Bool{
    if ignoreCase {
        return s1.lowercaseString.compare(s2.lowercaseString) == .OrderedSame
    }
    
    return s1.compare(s2) == .OrderedSame
}
