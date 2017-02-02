//
//  RoomScheduleBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

class RoomScheduleBuilder {
    
    var roomSchedule: RoomSchedule
    var minutesTillNextEvent: Int?
    
    typealias EventBuilder = CalendarEventBuilder
    private init(schedule: RoomSchedule) {
        self.roomSchedule = schedule
    }
    
    class func freeRoomSchedule () -> RoomScheduleBuilder {
        let freeSchedule = RoomSchedule.createFreeRoomSchedule()
        return RoomScheduleBuilder(schedule: freeSchedule)
    }
    
    func withNextEventStartsIn(minutes: Int) -> RoomScheduleBuilder {
        minutesTillNextEvent = minutes
        return self
    }
    
    func build() -> RoomSchedule {
        let schedule = RoomSchedule()
        schedule.isBusyNow = roomSchedule.isBusyNow
        if schedule.isBusyNow {
            schedule.currentEvent =
                EventBuilder
                    .currentCalendarEvents(withLength: oneHour)
                    .build()
            schedule.nextAvailable = schedule.currentEvent?.endDatetime
        } else {
            schedule.minutesTillNextEvent = minutesTillNextEvent
        }
        
        return schedule
    }
}
