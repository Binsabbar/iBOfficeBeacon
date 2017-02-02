//
//  CalendarEvent.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class CalendarEvent {
    
    let startDatetime: NSDate
    let endDatetime: NSDate
    let title: NSString
    
    init(start: NSDate, end: NSDate, title: NSString) {
        if(start.isLaterThanDate(end)) {
            preconditionFailure("Event start time cannot be later than event end time")
        }
        
        startDatetime = start
        endDatetime = end
        self.title = title
    }
    
    func isConsecutiveToAnotherEvent(event: CalendarEvent) -> Bool {
        return self.startDatetime == event.endDatetime ||
            ( self.startDatetime.isLaterThanDate(event.endDatetime) &&
            self.startDatetime.timeIntervalSinceDate(event.endDatetime) < 61)
    }
    
    func isEqualTo(anotherEvent: CalendarEvent) -> Bool {
        return self.startDatetime == anotherEvent.startDatetime &&
            self.endDatetime == anotherEvent.endDatetime &&
            self.title == anotherEvent.title
    }
    
    func isAllDayEvent() -> Bool {
        let start = startDatetime.beginningOfDay()
        let end = start.tomorrow()
        
        return start.compareDateToSecondPrecision(startDatetime) == .OrderedSame &&
            end.compareDateToSecondPrecision(endDatetime) == .OrderedSame
    }
}
