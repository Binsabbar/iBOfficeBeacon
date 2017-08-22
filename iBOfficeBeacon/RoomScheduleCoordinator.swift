//
//  RoomSchedulCoordinator.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class RoomScheduleCoordinator {

    var datetimeNow: Date!
    let timeslotsCalculator: FreeTimeslotCalculator
    let MAX_TIMESLOT_MINUTES = 120
    
    init(timeslotsCalculator: FreeTimeslotCalculator) {
        self.timeslotsCalculator = timeslotsCalculator
    }
    
    func findCurrentRoomScheduleFromEvents(_ events: [CalendarEvent]) -> ScheduleProtocol {
        datetimeNow = Date()
        
        let sortedEvents = sortEventsInAscendingOrder(filterOutPastEvents(events))
        
        if sortedEvents.count > 0 {
            return self.processEvents(sortedEvents)
        } else {
            let freeTimeslots = timeslotsCalculator.calculateFreeTimeslotsFrom(minutes: MAX_TIMESLOT_MINUTES)
            return FreeSchedule(for: 0, with: freeTimeslots)
        }
    }
    
    fileprivate func processEvents(_ events: [CalendarEvent]) ->  ScheduleProtocol {
        let firstEvent = events.first!
        
        if isACurrentEvent(firstEvent) {
            var previousEvent = firstEvent
            var endDatetimeOfLastConsecutiveEvent = previousEvent.endDatetime
            for i in 1 ..< events.count {
                if events[i].isConsecutiveToAnotherEvent(previousEvent) {
                    previousEvent = events[i]
                    endDatetimeOfLastConsecutiveEvent = previousEvent.endDatetime
                } else { break }
            }
            return BusySchedule(with: firstEvent,
                                nextAvailable: endDatetimeOfLastConsecutiveEvent)
        }
        
        let minutesTillNextEvent = timeIntervalInMinutesFromDate(firstEvent.startDatetime as Date)
        let freeTimeslots = timeslotsCalculator.calculateFreeTimeslotsFrom(minutes: minutesTillNextEvent)
        return FreeSchedule(for: minutesTillNextEvent, with: freeTimeslots)
    }
    

    fileprivate func filterOutPastEvents(_ events: [CalendarEvent]) -> [CalendarEvent] {
        return events.filter { (event) -> Bool in
            return datetimeNow.isEarlierThanDate(event.endDatetime)
        }
    }
    
    fileprivate func sortEventsInAscendingOrder(_ events: [CalendarEvent]) -> [CalendarEvent] {
        return events.sorted { (event, anotherEvent) -> Bool in
            return event.startDatetime.isEarlierThanDate(anotherEvent.startDatetime)
        }
    }
    
    fileprivate func timeIntervalInMinutesFromDate(_ date: Date) -> Int {
        return Int(ceil(date.timeIntervalSince(datetimeNow)/60))
    }
    
    fileprivate func isACurrentEvent(_ event: CalendarEvent) -> Bool {
        return event.startDatetime.isEarlierThanDate(datetimeNow) &&
            event.endDatetime.isLaterThanDate(datetimeNow)
    }
}
