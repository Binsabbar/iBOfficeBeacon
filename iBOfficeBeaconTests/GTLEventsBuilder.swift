//
//  GTLEventsBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
class GTLTCalendar_EventsBuilder {
    
    static func buildGTLRCalendar_EventsForCalendarID(calendarID: String, limitTo limit: Int)
        -> GTLRCalendar_Events {
        
        let events = GTLRCalendar_Events()
        var items = [GTLRCalendar_Event]()
        
        var hourOffset = NSTimeInterval(0)
        for _ in 1...limit {
            let date = NSDate().dateByAddingTimeInterval(hourOffset)
            items.append(buildGTLRCalendar_EventForCalendarID(calendarID, withDate: date))
            hourOffset = (oneHour*2) + hourOffset
        }
        events.items = items
        return events
    }
    
    static func buildGTLRCalendar_EventsForAllDayEventForCalendarID(calendarID: String) -> GTLRCalendar_Events {
        let events = GTLRCalendar_Events()
        let allDayEvent = buildGTLRCalendar_EventForAllDayEventForCalendarID(calendarID)
        
        events.items = [allDayEvent]
    
        return events
    }
    
    static func buildEventAttendeesForCalendarID(calendarID: String, withDeclinedResponse declined: Bool)
        -> [GTLRCalendar_EventAttendee] {
        
        let room = GTLRCalendar_EventAttendee()
        room.displayName = "Unit Test"
        room.email = calendarID
        room.responseStatus = declined ? "declined" : "accepted"
        
        let attendee = GTLRCalendar_EventAttendee()
        attendee.displayName = "Random Attendee"
        attendee.email = "attendee@gmail.com"
        attendee.responseStatus = "accepted"
        
        return [attendee, room]
    }
    
    static func buildGTLCalanerEventsFromEvents(events: [GTLRCalendar_Event])
        -> GTLRCalendar_Events {
            
        let event = GTLRCalendar_Events()
        event.items = events
        return event
    }
    
    static func buildGTLRCalendar_EventForCalendarID(calendarID: String, withDate date: NSDate)
        -> GTLRCalendar_Event {
        
        let timeZoneOffsetMinutes = NSTimeZone.localTimeZone().secondsFromGMT / 60
        let event = GTLRCalendar_Event()
        
        event.start = GTLRCalendar_EventDateTime()
        event.start!.dateTime = GTLRDateTime(date: date, offsetMinutes: timeZoneOffsetMinutes)
        
        event.end = GTLRCalendar_EventDateTime()
        event.end!.dateTime = GTLRDateTime(date: date.dateByAddingTimeInterval(oneHour), offsetMinutes: timeZoneOffsetMinutes)
        
        event.summary = "Event Summary for \(date.description)"
        event.attendees = buildEventAttendeesForCalendarID(calendarID, withDeclinedResponse: false)
        return event
    }
    
    static func buildGTLRCalendar_EventForAllDayEventForCalendarID(calendarID: String)
        -> GTLRCalendar_Event {
            let event = GTLRCalendar_Event()
            
            // all day event end date = start date + one day
            // (think of timezones when testing in different timezone, NSDate is always UTC)
            event.start = GTLRCalendar_EventDateTime()
            event.start!.date = GTLRDateTime(forAllDayWithDate: NSDate.todayInUTC())
        
            event.end = GTLRCalendar_EventDateTime()
            event.end!.date = GTLRDateTime(forAllDayWithDate: NSDate.tomorrowInUTC())
            
            event.summary = "All day event"
            event.attendees = buildEventAttendeesForCalendarID(calendarID, withDeclinedResponse: false)
            return event
    }
}
