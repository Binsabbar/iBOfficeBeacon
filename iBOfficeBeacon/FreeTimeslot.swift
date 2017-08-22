//
//  FreeTimeslot.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

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


class FreeTimeslot: Hashable {

    let duration: FreeTimeslotDuration
    let from: Date
    let to: Date
    
    init(duration: FreeTimeslotDuration, from: Date, to: Date) {
        self.duration = duration
        self.from = from
        self.to = to
    }
    
    var hashValue: Int {
        return "\(to),\(from),\(duration))".hashValue
    }
}

func ==(lhs: FreeTimeslot, rhs: FreeTimeslot) -> Bool {
    return lhs.duration == rhs.duration &&
        (lhs.from == rhs.from) &&
        (lhs.to == rhs.to)
}

func == (lhs: FreeTimeslotDuration, rhs: FreeTimeslotDuration) -> Bool {
    return lhs.minutes() == rhs.minutes()
}
