//
//  FreeTimeslot.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation


class FreeTimeslot {

    let duration: FreeTimeslotDuration
    let from: NSDate
    let to: NSDate
    
    init(duration: FreeTimeslotDuration, from: NSDate, to: NSDate) {
        self.duration = duration
        self.from = from
        self.to = to
    }
}

enum FreeTimeslotDuration: Hashable {
    
    case lessThanHalfAnHour(minutes: Int), halfAnHour, oneHour, twoHours
    
    func minutes()-> Int {
        switch self {
        case let .lessThanHalfAnHour(minutes):
            return minutes
        case .halfAnHour:
            return 30
        case .oneHour:
            return 60
        case .twoHours:
            return 120
        }
    }
    
    var hashValue: Int { return minutes() }
}


func == (lhs: FreeTimeslotDuration, rhs: FreeTimeslotDuration) -> Bool {
    return lhs.minutes() == rhs.minutes()
}
