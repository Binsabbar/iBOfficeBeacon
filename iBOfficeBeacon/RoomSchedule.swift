//
//  RoomSchedule.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 14/02/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

protocol ScheduleProtocol {
    var isBusy: Bool { get }
    var availableTimeslots: Set<FreeTimeslot> { get }
    var minutesTillNextEvent: Int { get }
}

class FreeSchedule: ScheduleProtocol {
    
    private let _minutesTillNextEvent: Int
    private let _availableTimeslots: Set<FreeTimeslot>
    
    var isBusy = false
    var availableTimeslots: Set<FreeTimeslot> { return _availableTimeslots }
    var minutesTillNextEvent: Int { return _minutesTillNextEvent }
    
    init(for minutes: Int, with availableTimeslots: Set<FreeTimeslot>) {
        _minutesTillNextEvent = minutes
        _availableTimeslots = availableTimeslots
    }
}

class BusySchedule: ScheduleProtocol {
    
    var isBusy = true
    var availableTimeslots = Set<FreeTimeslot>()
    var minutesTillNextEvent = 0
    
    let nextAvailable: NSDate
    let currentEvent: CalendarEvent
    
    init(with event: CalendarEvent, nextAvailable: NSDate) {
        currentEvent = event
        self.nextAvailable = nextAvailable
    }
}
