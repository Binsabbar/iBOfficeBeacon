//
//  CalendarQueryFactory.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class CalendarQueryFactory {
    
    static let queryTimeZone = TimeZone(abbreviation: "UTC")
    static let eightAM = 8
    static let eightPM = 20
    static let maxEvent = 30
    
    static func listEventsQueryForCalendarWithID(_ calendarID: String) -> GTLRCalendarQuery_EventsList {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarID)
        query.maxResults = maxEvent
        query.singleEvents = true
        query.timeMin = GTLRDateTime(date: Date.todayWithHours(eightAM, andMinutes: 0))
        query.timeMax = GTLRDateTime(date: Date.todayWithHours(eightPM, andMinutes: 0))
        query.orderBy = kGTLRCalendarOrderByStartTime
        query.timeZone = queryTimeZone?.abbreviation()
        return query
    }
    
    static func insertEventRequestForEvent(_ event: GTLRCalendar_Event) -> GTLRCalendarQuery_EventsInsert {
        event.summary = "Booked by iBOfficeBeacon for iOS"
        let query = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: "primary")
        return query
    }
}
