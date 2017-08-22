//
//  CalendarQueryFactoryUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class CalendarQueryFactoryUnitTest: XCTestCase {
    
    let calendarID = "some-id"
    let maxEventResults = 30
    let methodName = "calendar.events.list"
    let timeZone = TimeZone(abbreviation: "UTC")

    var query: GTLRCalendarQuery_EventsList!
    
    override func setUp() {
        super.setUp()
        query = CalendarQueryFactory.listEventsQueryForCalendarWithID(calendarID)
    }
    
    //MARK: ListEventQuery - #listEventsQueryForCalendarWithID
    func testItCreatesGTLQueryCalendarWithTheGivenCalendarID() {
        XCTAssertTrue(query.calendarId == calendarID)
    }
    
    func testItSetsTheMaxResultsToTen() {
        XCTAssertTrue(query.maxResults == maxEventResults)
    }
    
    func testItSetsSingleEventToTrue() {
        XCTAssertTrue(query.singleEvents)
    }
    
    
    func testItSetsMinDatetimeToTodayAtEightAM() {
        let today = Date.todayWithHours(8, andMinutes: 00)
        let datetime = GTLRDateTime(date: today)
        
        XCTAssertTrue(query.timeMin == datetime)
    }
    
    func testItSetsMaxDatetimeToTodayAtEightPM() {
        let today = Date.todayWithHours(20, andMinutes: 00)
        let datetime = GTLRDateTime(date: today)
        
        XCTAssertTrue(query.timeMax == datetime)
    }
    
    func testItSetsTimeZoneToUTC() {
        XCTAssertTrue(query.timeZone == timeZone?.abbreviation())
    }
    
    func testItSetsOrderByStartTime() {
        XCTAssertTrue(query.orderBy == kGTLRCalendarOrderByStartTime)
    }
    
    //MARK: InsertEventQuery - #insertEventRequestForCalendarWithID
    func testItReturnsInsertEventQuery() {
        let event = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventForCalendarID("some-id", withDate: Date())
        
        let query = CalendarQueryFactory.insertEventRequestForEvent(event)
        
        XCTAssertEqual(event, query.bodyObject)
        XCTAssertEqual("primary", query.calendarId)
    }
}
