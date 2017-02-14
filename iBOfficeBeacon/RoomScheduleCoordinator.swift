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
    
    init(timeslotsCalculator: FreeTimeslotCalculator) {
        self.timeslotsCalculator = timeslotsCalculator
    }
    
    func findCurrentRoomScheduleFromEvents(events: [CalendarEvent]) -> RoomSchedule {
        datetimeNow = NSDate()
        var schedule: RoomSchedule
        let sortedEvents = sortEventsInAscendingOrder(filterOutPastEvents(events))
        
        if sortedEvents.count > 0 {
            schedule = self.processMultipleEvents(sortedEvents)
        } else {
            schedule = RoomSchedule.createFreeRoomSchedule()
        }
        
        schedule.availableTimeSlots = timeslotsCalculator.calculateFreeTimeslotsIn(schedule)
        
        return schedule
    }
    
    private func processMultipleEvents(events: [CalendarEvent]) ->  RoomSchedule {
        let firstEvent = events.first!
        let schedule = processSingleEvent(firstEvent)
        
        if isACurrentEvent(firstEvent) {
            var previousEvent = firstEvent
            var endDatetimeOfLastConsecutiveEvent = previousEvent.endDatetime
            for i in 1 ..< events.count {
                if events[i].isConsecutiveToAnotherEvent(previousEvent) {
                    previousEvent = events[i]
                    endDatetimeOfLastConsecutiveEvent = previousEvent.endDatetime
                } else {
                    break
                }
            }
            schedule.nextAvailable = endDatetimeOfLastConsecutiveEvent
        }
        
        return schedule
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
    
    private func processSingleEvent(event: CalendarEvent) -> RoomSchedule {
        let schedule = RoomSchedule()
        
        schedule.isBusyNow = isACurrentEvent(event)
        
        if schedule.isBusyNow {
            schedule.nextAvailable = event.endDatetime
            schedule.currentEvent = event
        } else if event.startDatetime.isLaterThanDate(datetimeNow){
            schedule.minutesTillNextEvent = timeIntervalInMinutesFromDate(event.startDatetime)
        }
        
        return schedule
    }
    
    private func timeIntervalInMinutesFromDate(date: NSDate) -> Int {
        return Int(ceil(date.timeIntervalSinceDate(datetimeNow)/60))
    }
    
    private func isACurrentEvent(event: CalendarEvent) -> Bool {
        return event.startDatetime.isEarlierThanDate(datetimeNow) &&
            event.endDatetime.isLaterThanDate(datetimeNow)
    }
}
