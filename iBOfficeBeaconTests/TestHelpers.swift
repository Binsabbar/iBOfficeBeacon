//
//  TestHelpers.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 07/02/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
import XCTest

let hundredMs = TimeInterval(0.1)
let halfSecond = TimeInterval(0.5)
let second = TimeInterval(1)
let twoSeconds = TimeInterval(2)
let fiveSeconds = TimeInterval(5)

let oneDay = TimeInterval(86400)
let oneHour = TimeInterval(3600)
let halfAnHour = TimeInterval(1800)
let pastHour = TimeInterval(-3600)
let past2Hours = TimeInterval(-3600) * 2


func fullfillExpectation(_ expection:XCTestExpectation, withinTime seconds: TimeInterval) {
    let delay = seconds * Double(NSEC_PER_SEC)
    let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: dispatchTime) { () -> Void in
        expection.fulfill()
    }
}

func compareDates(_ firstDate: Date, otherDate: Date) -> Bool {
    let result = (Calendar.current as NSCalendar).compare(firstDate, to: otherDate,
                                                          toUnitGranularity: .second)
    return result == .orderedSame
}

func isString(firstString s1: String, equalsToOtherString s2: String, ignoreCase: Bool=true) -> Bool{
    if ignoreCase {
        return s1.lowercased().compare(s2.lowercased()) == .orderedSame
    }
    
    return s1.compare(s2) == .orderedSame
}
