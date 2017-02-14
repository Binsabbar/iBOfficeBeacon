//
//  RoomScheduleBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

class RoomScheduleBuilder {

    private let isBusy: Bool
    private var minutesTillNextEvent: Int = 0
    private var timeslots = Set<FreeTimeslot>()
    private var event: CalendarEvent?
    private var availableAt = NSDate()
    
    typealias EventBuilder = CalendarEventBuilder
    
    private init(timeslots: Set<FreeTimeslot>) {
        isBusy = false
        self.timeslots = timeslots
    }
    
    private init(event: CalendarEvent) {
        isBusy = true
        availableAt = event.endDatetime
        self.event = event
    }
    
    class func free(with timeslots: Set<FreeTimeslot>) -> RoomScheduleBuilder {
        return RoomScheduleBuilder(timeslots: timeslots)
    }
    
    class func busy(with event: CalendarEvent) -> RoomScheduleBuilder {
        return RoomScheduleBuilder(event: event)
    }
    
    func withAvailableAt(availableAt: NSDate) -> RoomScheduleBuilder {
        self.availableAt = availableAt
        return self
    }
    
    func withNextEvent(startsIn minutes: Int) -> RoomScheduleBuilder {
        minutesTillNextEvent = minutes
        return self
    }
    
    func build() -> ScheduleProtocol {
        if isBusy {
         return FreeSchedule(for: minutesTillNextEvent, with: timeslots)
        } else {
            return BusySchedule(with: event!, nextAvailable: availableAt)
        }
    }
}
