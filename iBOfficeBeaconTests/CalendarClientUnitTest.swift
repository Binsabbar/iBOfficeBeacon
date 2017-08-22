//
//  CalendarClientUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class CalendarClientUnitTest: XCTestCase {

    var service: GTLRCalendarService!
    var subject: CalendarClient!
    let calendarID = "CalendarClientUnitTest"
    let dummyError = NSError(domain: "", code: 1, userInfo: nil)
    var errorHandler:ErrorHandlingProtocol!
    
    var event: GTLRCalendar_Event!
    
    override func setUp() {
        super.setUp()
        errorHandler = ErrorHandlerSpy()
        service = GTLRCalendarService()
        subject = CalendarClient(withGoogleService: service, errorHandler: errorHandler)
        event = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventForCalendarID(calendarID, withDate: Date())
    }

    //MARK: #fetchEventsForCalendarWithID (FE)
    func testItCallsCalendarServiceWithTheListEventsQuery() {
        let fakeEvents = GTLTCalendar_EventsBuilder.buildGTLRCalendar_EventsForCalendarID(calendarID, limitTo: 2)
        let query = CalendarQueryFactory.listEventsQueryForCalendarWithID(calendarID)
    
        subject.fetchEventsForCalendarWithID(calendarID, onFetched: { (events) in
            
            }, onFailur: {_ in })

        
        service.testBlock = { (ticket, testResponse) in
            let calledQuery = ticket.originalQuery as! GTLRCalendarQuery_EventsGet
            XCTAssertTrue(calledQuery.httpMethod == query.httpMethod)
            XCTAssertTrue(calledQuery.calendarId == query.calendarId)
            testResponse(fakeEvents, nil)
        }
    }
    
    func testItCallsErrorHandlerWhenFetchingEventsFails() {
        let expectation = self.expectation(description: "Fetching Event")
        service.testBlock = { (_, testResponse) in
            testResponse(nil, self.dummyError)
        }
        
        subject.fetchEventsForCalendarWithID(calendarID, onFetched: { _ in },
                                             onFailur: {_ in
            expectation.fulfill()
        })
        waitForExpectations(timeout: hundredMs) { _ in
            XCTAssertTrue((self.errorHandler as! ErrorHandlerSpy).handleErrorIsCalled)
            XCTAssertEqual((self.errorHandler as! ErrorHandlerSpy).calledError, self.dummyError)
        }
    }
    
    func testItCallsBackWithTrueWhenInsertingAnEventSuceeded() {
        let expectation = self.expectation(description: "Asyn Insert Event")
        
        service.testBlock = { (_, testResponse) in
            testResponse(nil, nil)
        }
        
        subject.insertEventAsync(event) { (result) in
            XCTAssertTrue(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: hundredMs, handler: nil)
    }
    
    func testItCallsBackWithFalseWhenInsertingAnEventFails() {
        let expectation = self.expectation(description: "Asyn Insert Event")
    
        service.testBlock = { (_, testResponse) in
            testResponse(nil, self.dummyError)
        }
        
        subject.insertEventAsync(event) { (result) in
            XCTAssertFalse(result)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: hundredMs, handler: nil)
    }
    
    func testItCallsErrorHandlerWhenInsertingAnEventFails() {
        let expectation = self.expectation(description: "Asyn Insert Event")
        service.testBlock = { (_, testResponse) in
            testResponse(nil, self.dummyError)
        }
        
        subject.insertEventAsync(event) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: hundredMs) { _ in
            XCTAssertTrue((self.errorHandler as! ErrorHandlerSpy).handleErrorIsCalled)
            XCTAssertEqual((self.errorHandler as! ErrorHandlerSpy).calledError, self.dummyError)
        }
    }
}
