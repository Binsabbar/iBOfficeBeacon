//
//  CalendarServiceUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class CalendarServiceIntegrationTest: XCTestCase {
    
    var subject: CalendarService!
    var coordinator: RoomScheduleCoordinator!
    var eventProcessor: CalendarEventsProcessor!
    var calendarClient: CalendarClient!
    var service: GTLRCalendarService!
    
    let calendarID = "CalendarServiceIntegrationTest"
    var officeRoom: OfficeRoom!
    
    override func setUp() {
        super.setUp()
        service = GTLRCalendarService()
        eventProcessor = CalendarEventsProcessor()
        coordinator = RoomScheduleCoordinator(timeslotsCalculator: FreeTimeslotCalculator())
        calendarClient = CalendarClient(withGoogleService: service, errorHandler: ErrorHandlerSpy())
        officeRoom = OfficeRoom(withName: "", calendarID: calendarID, minor: 12)
        subject = CalendarService(calendarClient: calendarClient,
                                  eventProcessor: eventProcessor,
                                  coordinator: coordinator)
    }

    //MARK: Context - when there is an event at the current time
    func testReturnsRoomScheduleWithIsBusyNowSetToTrue() {
        let event = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventForCalendarID(calendarID, withDate: Date())
        let gtlEvents = GTLTCalendar_EventsBuilder.buildGTLCalanerEventsFromEvents([event])
        let expectation = self.expectation(description: "CalendarServiceIntegrationTest")
        service.testBlock = { (ticket, testResponse) in
            testResponse(gtlEvents, nil)
        }
        
        subject.findScheduleForRoom(officeRoom) { (result) in
            XCTAssertTrue(result!.isBusy)
            XCTAssertNotNil(result as? BusySchedule)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: hundredMs, handler: nil)
    }
    
    //MARK: Context - when there is no event at the current time
    func testReturnsRoomScheduleWithIsBusyNowSetToFalse() {
        let expectation = self.expectation(description: "CalendarServiceIntegrationTest")
        let pastDate = Date().addingTimeInterval(past2Hours)
        let pastEvent = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventForCalendarID(calendarID, withDate: pastDate)
        
        let futureDate = Date().addingTimeInterval(oneHour)
        let futureEvent = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventForCalendarID(calendarID, withDate: futureDate)
        
        let gtlEvents = GTLTCalendar_EventsBuilder.buildGTLCalanerEventsFromEvents([pastEvent, futureEvent])
        
        service.testBlock = { (ticket, testResponse) in
            testResponse(gtlEvents, nil)
        }
        
        subject.findScheduleForRoom(officeRoom) { (result) in
            let minutes = ceil(futureDate.timeIntervalSinceNow/60)
            
            XCTAssertFalse(result!.isBusy)
            XCTAssertTrue(result!.minutesTillNextEvent == Int(minutes))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: hundredMs, handler: nil)
    }
    
    //MARK: Book a room - #bookRoomNow
    //Context: Context when there are more than 30 minutes available
    func testItBooksARoomFor30MinutesAndCallsBackWithTrue() {
        let expectation = self.expectation(description: "Calendar Service Book Room")
        let eventStartTime = Date()
        let eventEndTime = eventStartTime.addingTimeInterval(halfAnHour)
        
        let currentSchedule = FreeSchedule(for: 40, with: Set())
        
        service.testBlock = {(ticket, testResponse) in
            let query = ticket.originalQuery as! GTLRCalendarQuery_EventsInsert
            let event = query.bodyObject as! GTLRCalendar_Event
            
            XCTAssertTrue(compareDates((event.start?.dateTime?.date)!, otherDate: eventStartTime))
            XCTAssertTrue(compareDates((event.end?.dateTime?.date)!, otherDate: eventEndTime))
            
            testResponse(GTLRObject(), nil)
        }
        
        subject.bookRoomAsync(officeRoom, withSchedule: currentSchedule) { (result) in
            XCTAssertTrue(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: hundredMs, handler: nil)
    }
    
    //Context: when there are less than 30 minutes available
    func testItBooksARoomForWhateverRemainingMinutesAndCallsBackWithTrue() {
        let expectation = self.expectation(description: "Calendar Service Book Room")
        
        let currentSchedule = FreeSchedule(for: 20, with: Set())
        let bookingLengthInMinutes:Double = 19
        
        let eventStartTime = Date()
        let eventEndTime = eventStartTime.addingTimeInterval(bookingLengthInMinutes * 60)
        
        service.testBlock = { (ticket, testResponse) in
            let query = ticket.originalQuery as! GTLRCalendarQuery_EventsInsert
            let event = query.bodyObject as! GTLRCalendar_Event
            XCTAssertTrue(compareDates((event.start?.dateTime?.date)!, otherDate: eventStartTime))
            XCTAssertTrue(compareDates((event.end?.dateTime?.date)!, otherDate: eventEndTime))
            testResponse(GTLRObject(), nil)
        }
        
        subject.bookRoomAsync(officeRoom, withSchedule: currentSchedule) { (result) in
            XCTAssertTrue(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: hundredMs, handler: nil)
    }
    
    func testItCallsBackWithFalseIfBookingRoomFails() {
        let expectation = self.expectation(description: "Calendar Service Book Room")
        
        let currentSchedule = FreeSchedule(for: 20, with: Set())
        
        service.testBlock = { (ticket, testResponse) in
            let dummyError = NSError(domain: "", code: 1, userInfo: nil)
            testResponse(nil, dummyError)
        }
        
        subject.bookRoomAsync(officeRoom, withSchedule: currentSchedule) { (result) in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: hundredMs, handler: nil)
    }
}
