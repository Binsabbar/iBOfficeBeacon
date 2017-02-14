//
//  RoomSchedulCoordinator.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class RoomScheduleCoordinator {

    var datetimeNow: NSDate!
    let timeslotsCalculator: FreeTimeslotCalculator
    let MAX_TIMESLOT_MINUTES = 120
    
    init(timeslotsCalculator: FreeTimeslotCalculator) {
        self.timeslotsCalculator = timeslotsCalculator
    }
    
    func findCurrentRoomScheduleFromEvents(events: [CalendarEvent]) -> ScheduleProtocol {
        datetimeNow = NSDate()
        
        let sortedEvents = sortEventsInAscendingOrder(filterOutPastEvents(events))
        
        if sortedEvents.count > 0 {
            return self.processEvents(sortedEvents)
        } else {
            let freeTimeslots = timeslotsCalculator.calculateFreeTimeslotsFrom(minutes: MAX_TIMESLOT_MINUTES)
            return FreeSchedule(for: 0, with: freeTimeslots)
        }
    }
    
    private func processEvents(events: [CalendarEvent]) ->  ScheduleProtocol {
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
        
        let minutesTillNextEvent = timeIntervalInMinutesFromDate(firstEvent.startDatetime)
        let freeTimeslots = timeslotsCalculator.calculateFreeTimeslotsFrom(minutes: minutesTillNextEvent)
        return FreeSchedule(for: minutesTillNextEvent, with: freeTimeslots)
    }
    

    private func filterOutPastEvents(events: [CalendarEvent]) -> [CalendarEvent] {
        return events.filter { (event) -> Bool in
            return datetimeNow.isEarlierThanDate(event.endDatetime)
        }
    }
    
    private func sortEventsInAscendingOrder(events: [CalendarEvent]) -> [CalendarEvent] {
        return events.sort { (event, anotherEvent) -> Bool in
            return event.startDatetime.isEarlierThanDate(anotherEvent.startDatetime)
        }
    }
    
    private func timeIntervalInMinutesFromDate(date: NSDate) -> Int {
        return Int(ceil(date.timeIntervalSinceDate(datetimeNow)/60))
    }
    
    private func isACurrentEvent(event: CalendarEvent) -> Bool {
        return event.startDatetime.isEarlierThanDate(datetimeNow) &&
            event.endDatetime.isLaterThanDate(datetimeNow)
    }
}
