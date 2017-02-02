//
//  Schedule.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

enum Timeslots:Int {
    case lessThanHalf=1
    case halfAnHour=2
    case oneHour=3
    case twoHours=4
}

class RoomSchedule:NSObject {
    var isBusyNow = false
    var nextAvailable: NSDate?
    var minutesTillNextEvent:Int?
    var currentEvent: CalendarEvent?
    var availableTimeSlots = Set<Timeslots>()

    class func createFreeRoomSchedule() -> RoomSchedule {
        let roomSchedule = RoomSchedule()
        roomSchedule.isBusyNow = false
        return roomSchedule
    }
}
