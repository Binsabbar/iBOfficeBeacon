//
//  CalendarEventBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

class CalendarEventBuilder {
    
    fileprivate var startDate = Date()
    fileprivate var endDate = Date()
    fileprivate var title = "default title"
    
    fileprivate init(startDate: Date, endDate: Date, title: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
    }
    
    
    class func currentCalendarEvents(withLength length: TimeInterval) -> CalendarEventBuilder {
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(length)
        let title = "Event built by builder"
        return CalendarEventBuilder(startDate: startDate, endDate: endDate, title: title)
    }
    
    class func futureCalendarEventsStartsIn(_ minutes: TimeInterval,
                                            withLength length: TimeInterval)
        -> CalendarEventBuilder {
            let startDate = Date().addingTimeInterval(minutes)
            let endDate = startDate.addingTimeInterval(length)
            let title = "Event built by builder"
            return CalendarEventBuilder(startDate: startDate, endDate: endDate, title: title)
    }
    
    func withTitle(_ title: String) -> CalendarEventBuilder {
        self.title = title
        return self
    }
    
    func build() -> CalendarEvent {
        return CalendarEvent(start: startDate, end: endDate, title: title)
    }
}
