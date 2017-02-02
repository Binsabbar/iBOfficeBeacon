//
//  CalendarEventBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

class CalendarEventBuilder {
    
    private var startDate = NSDate()
    private var endDate = NSDate()
    private var title = "default title"
    
    private init(startDate: NSDate, endDate: NSDate, title: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
    }
    
    
    class func currentCalendarEvents(withLength length: NSTimeInterval) -> CalendarEventBuilder {
        let startDate = NSDate()
        let endDate = startDate.dateByAddingTimeInterval(length)
        let title = "Event built by builder"
        return CalendarEventBuilder(startDate: startDate, endDate: endDate, title: title)
    }
    
    class func futureCalendarEventsStartsIn(minutes: NSTimeInterval,
                                            withLength length: NSTimeInterval)
        -> CalendarEventBuilder {
            let startDate = NSDate().dateByAddingTimeInterval(minutes)
            let endDate = startDate.dateByAddingTimeInterval(length)
            let title = "Event built by builder"
            return CalendarEventBuilder(startDate: startDate, endDate: endDate, title: title)
    }
    
    func withTitle(title: String) -> CalendarEventBuilder {
        self.title = title
        return self
    }
    
    func build() -> CalendarEvent {
        return CalendarEvent(start: startDate, end: endDate, title: title)
    }
}
