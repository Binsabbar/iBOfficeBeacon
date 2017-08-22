//
//  RoomScheduleBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

class RoomScheduleBuilder {

    fileprivate let isBusy: Bool
    fileprivate var minutesTillNextEvent: Int = 0
    fileprivate var timeslots = Set<FreeTimeslot>()
    fileprivate var event: CalendarEvent?
    fileprivate var availableAt = Date()
    
    typealias EventBuilder = CalendarEventBuilder
    
    fileprivate init(timeslots: Set<FreeTimeslot>) {
        isBusy = false
        self.timeslots = timeslots
    }
    
    fileprivate init(event: CalendarEvent) {
        isBusy = true
        availableAt = event.endDatetime as Date
        self.event = event
    }
    
    class func free(with timeslots: Set<FreeTimeslot>) -> RoomScheduleBuilder {
        return RoomScheduleBuilder(timeslots: timeslots)
    }
    
    class func busy(with event: CalendarEvent) -> RoomScheduleBuilder {
        return RoomScheduleBuilder(event: event)
    }
    
    func withAvailableAt(_ availableAt: Date) -> RoomScheduleBuilder {
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
