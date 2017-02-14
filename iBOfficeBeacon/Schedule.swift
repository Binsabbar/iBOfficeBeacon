//
//  Schedule.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class RoomSchedule:NSObject {
    
    var isBusyNow = false
    var minutesTillNextEvent:Int?
    var availableTimeSlots = Set<FreeTimeslot>()
    var nextAvailable: NSDate?
    var currentEvent: CalendarEvent?

    class func createFreeRoomSchedule() -> RoomSchedule {
        let roomSchedule = RoomSchedule()
        roomSchedule.isBusyNow = false
        return roomSchedule
    }
}
