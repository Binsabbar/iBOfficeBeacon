//
//  CalendarEventsProcessorUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class CalendarEventsProcessorUnitTest: XCTestCase {

    var subject: CalendarEventsProcessor!
    var googleEvents: GTLRCalendar_Events!
    
    let oneHour = TimeInterval(3600)
    let calendarID = "CalendarEventsProcessorUnitTest"
    
    override func setUp() {
        super.setUp()
        let totalNumberOfEvents = 4
        subject = CalendarEventsProcessor()
        googleEvents = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventsForCalendarID(calendarID, limitTo: totalNumberOfEvents)
    }
    
    //MARK: Google Event Processing
    
    func testItCreatesCalendarEventArrayFromGoogleGTLRCalendar_Events() {
        let eventsFromGoogle = googleEvents.items
        
        let results = subject.processEvents(googleEvents, forCalendarWithID: calendarID)
        
        for i in 0..<results.count {
            XCTAssertEqual(results[i].startDatetime, eventsFromGoogle![i].start!.dateTime!.date)
            XCTAssertEqual(results[i].endDatetime, eventsFromGoogle![i].end!.dateTime!.date)
            XCTAssertEqual(results[i].title, eventsFromGoogle![i].summary)
        }
    }
    
    func testItDoesNotAddCalendarEventIfGoogleStartDateOrEndDateIsNil() {
        let brokenEvent = GTLRCalendar_Event()
        brokenEvent.start = GTLRCalendar_EventDateTime()
        let expectedValidEvents = 2
        let events = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventsForCalendarID(calendarID, limitTo: expectedValidEvents)
        events.items?.append(brokenEvent)
        
        let results = subject.processEvents(events, forCalendarWithID: calendarID)
        
        XCTAssertTrue(results.count == expectedValidEvents)
    }

    func testItReturnsEmptyCalendarEventArrayWhenThereAreNoEvents() {
        let googleEvents = GTLRCalendar_Events()
        
        let results = subject.processEvents(googleEvents, forCalendarWithID: calendarID)
        
        XCTAssertTrue(results.count == 0)
    }
    
    func testItDoesNotAddTheEventIfTheRoomHasResponseStatusEqualToDeclined() {
        let eventsWithAcceptResponse = 3
        googleEvents.items!.first!.attendees = GTLTCalendar_EventsBuilder.buildEventAttendeesForCalendarID(calendarID,
                                                                                 withDeclinedResponse: true)
        
        let results = subject.processEvents(googleEvents, forCalendarWithID: calendarID)
        
        XCTAssertTrue(results.count == eventsWithAcceptResponse)
    }
    
    func testItProcessesAllDayEvent() {
        let allDayEvents = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventsForAllDayEventForCalendarID(calendarID)
        
        let results = subject.processEvents(allDayEvents, forCalendarWithID: calendarID)
        let event = results.first!
        
        let startOfToday = Date().beginningOfDayUTC()
        let tomorrow = Date.tomorrowInUTC().beginningOfDayUTC()
        XCTAssertTrue(event.startDatetime == startOfToday)
        XCTAssertTrue(event.endDatetime == tomorrow)
    }
    
    //MARK: Google Events creation
    func testItCreatesGTLREventWithAttendees() {
        let start = Date()
        let end = start.addingTimeInterval(oneHour)
        let attendees = ["attendee1@gmail.com", "attendee2@gmail.com"]
        
        let event = subject.eventStartsAt(start, endsAt: end, includesAttendees: attendees)
        
        for attendee in event.attendees! {
            XCTAssertTrue(attendees.contains(attendee.email!))
        }
    }
    
    func testItCreatesGTLREventWithStartAndEndtimes() {
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(oneHour)
        let attendees = ["attendee1@gmail.com", "attendee2@gmail.com"]
        
        let event = subject.eventStartsAt(startTime, endsAt: endTime, includesAttendees: attendees)
        
        XCTAssertTrue(compareDates(event.start!.dateTime!.date, otherDate: startTime))
        XCTAssertTrue(compareDates(event.end!.dateTime!.date, otherDate: endTime))
    }
}
