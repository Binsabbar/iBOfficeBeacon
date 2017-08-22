//
//  CalendarEvent.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class CalendarEvent {
    
    let startDatetime: Date
    let endDatetime: Date
    let title: String
    
    init(start: Date, end: Date, title: String) {
        if(start.isLaterThanDate(end)) {
            preconditionFailure("Event start time cannot be later than event end time")
        }
        
        startDatetime = start
        endDatetime = end
        self.title = title
    }
    
    func isConsecutiveToAnotherEvent(_ event: CalendarEvent) -> Bool {
        return self.startDatetime == event.endDatetime ||
            ( self.startDatetime.isLaterThanDate(event.endDatetime) &&
            self.startDatetime.timeIntervalSince(event.endDatetime) < 61)
    }
    
    func isEqualTo(_ anotherEvent: CalendarEvent) -> Bool {
        return self.startDatetime == anotherEvent.startDatetime &&
            self.endDatetime == anotherEvent.endDatetime &&
            self.title == anotherEvent.title
    }
    
    func isAllDayEvent() -> Bool {
        let start = startDatetime.beginningOfDay()
        let end = start.tomorrow()
        
        return start.compareDateToSecondPrecision(startDatetime) == .orderedSame &&
            end.compareDateToSecondPrecision(endDatetime) == .orderedSame
    }
}
