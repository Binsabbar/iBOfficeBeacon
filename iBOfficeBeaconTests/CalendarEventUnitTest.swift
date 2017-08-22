//
//  CalendarEventUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class CalendarEventUnitTest: XCTestCase {

    let eventTitle = "Unit Test Title"
    
    override func setUp() {
        super.setUp()
    }
    
    func testItReturnsTrueWhenEventIsConsecutiveToAnother() {
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(oneHour)
        let event = CalendarEvent(start: startTime, end: endTime, title: eventTitle)
        
        let anotherStartTime = endTime
        let anotherEndTime = anotherStartTime.addingTimeInterval(oneHour)
        let consecutiveEvent = CalendarEvent(start: anotherStartTime, end: anotherEndTime, title: eventTitle)
        
        let result = consecutiveEvent.isConsecutiveToAnotherEvent(event)
        
        XCTAssertTrue(result)
    }
    
    func testItReturnsFalseWhenEventIsNotConsecutiveToAnother() {
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(oneHour)
        let event = CalendarEvent(start: startTime, end: endTime, title: eventTitle)
        
        let anotherStartTime = endTime.addingTimeInterval(oneHour)
        let anotherEndTime = anotherStartTime.addingTimeInterval(oneHour)
        let laterEvent = CalendarEvent(start: anotherStartTime, end: anotherEndTime, title: eventTitle)
        
        let result = laterEvent.isConsecutiveToAnotherEvent(event)
        
        XCTAssertFalse(result)
    }
    
    //MARK: isAllDayEvent
    func testItReturnsTrueForAllDayEventsWhenStartsAtMidnightAndEndsNextDayMidnight() {
        let startTime = Date().beginningOfDay()
        let endTime = startTime.tomorrow()
        
        let event = CalendarEvent(start: startTime, end: endTime, title: eventTitle)
        
        XCTAssertTrue(event.isAllDayEvent())
    }
    
    func testItReturnsFalseForAllDayEventsWhenStartsAndEndsInTheSameDay() {
        let startTime = Date().beginningOfDay()
        let endTime = startTime.addingTimeInterval(oneHour)
        
        let event = CalendarEvent(start: startTime, end: endTime, title: eventTitle)
        
        XCTAssertFalse(event.isAllDayEvent())
    }
    
}
