//
//  CalendarEventProcessor.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

class CalendarEventsProcessor: NSObject {

    let responseAccepted = "accepted"
    
    func processEvents(_ events: GTLRCalendar_Events, forCalendarWithID calendarID: String) -> [CalendarEvent] {
        var processedEvents = [CalendarEvent]()

        if let calendarEvents = events.items {
            for event in calendarEvents {
                if hasCalendarID(calendarID, acceptedEvent: event) {
                    let eventTime = setEventTime(event)
                    let title = event.summary ?? "NO TITLE"
                    if let start = eventTime.start, let end = eventTime.end {
                        let calendarEvent = CalendarEvent(start: start, end: end, title: title)
                        processedEvents.append(calendarEvent)
                    }
                }
            }
        }
        return processedEvents
    }
    
    func eventStartsAt(_ date: Date, endsAt: Date, includesAttendees attendees: [String]) -> GTLRCalendar_Event {
        var eventAttendees = Array<GTLRCalendar_EventAttendee>()
        attendees.forEach { (attendeeEmail) in
            let attendee = GTLRCalendar_EventAttendee()
            attendee.email = attendeeEmail
            eventAttendees.append(attendee)
        }
      
        let event = GTLRCalendar_Event()
        
        event.start = GTLRCalendar_EventDateTime()
        event.end = GTLRCalendar_EventDateTime()
        event.start!.dateTime = GTLRDateTime(date: date)
        event.end!.dateTime = GTLRDateTime(date: endsAt)
        event.attendees = eventAttendees
        
        return event
    }

    typealias EventTime = (start: Date?, end: Date?)
    fileprivate func setEventTime(_ event: GTLRCalendar_Event) -> EventTime {
        if isAllDayEvent(event) {
            return(event.start?.date?.date.beginningOfDayUTC(),
                   event.end?.date?.date.beginningOfDayUTC())
        } else {
            return (event.start?.dateTime?.date, event.end?.dateTime?.date)
        }
    }
    
    fileprivate func isAllDayEvent(_ event: GTLRCalendar_Event) -> Bool {
        return event.start?.dateTime == nil && event.start?.date != nil
    }
    
    fileprivate func hasCalendarID(_ calendarID: String, acceptedEvent event: GTLRCalendar_Event) -> Bool {
        if let attendees = event.attendees {
            for attendee in attendees {
                if let email = attendee.email, let response = attendee.responseStatus, email == calendarID && response == responseAccepted {
                    return true
                }
            }
        }
        
        return false
    }
}
