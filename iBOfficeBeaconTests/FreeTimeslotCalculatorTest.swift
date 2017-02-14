//
//  FreeTimeslotCalculatorTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import XCTest

class FreeTimeslotCalculatorTest: XCTestCase {
    
    typealias Builder = RoomScheduleBuilder
    var subject: FreeTimeslotCalculator!
    
    override func setUp() {
        super.setUp()
        subject = FreeTimeslotCalculator()
    }
    
    
    func testItReturnsLessHalfAnHourTimeslotIfRoomIsAvailableForLessThanHalfAnHour() {
        let schedule = Builder.freeRoomSchedule().withNextEventStartsIn(29).build()
        
        let result: [FreeTimeslot] = subject.calculateFreeTimeslotsIn(schedule)
        
        XCTAssertTrue(result.count == 1)
        XCTAssertEqual(result.first!.duration, FreeTimeslotDuration.lessThanHalfAnHour(minutes: 29))
    }
    
    func testItReturnsHalfAnHourTimeslot() {
        let schedule = Builder.freeRoomSchedule().withNextEventStartsIn(35).build()
        
        let result: [FreeTimeslot] = subject.calculateFreeTimeslotsIn(schedule)
        
        XCTAssertTrue(result.count == 1)
        XCTAssertEqual(result.first!.duration, FreeTimeslotDuration.halfAnHour)
    }
    
    
    func testItReturnsTwoTimeslotIfRoomIsAvailableForMoreThanOneHour() {
        let schedule = Builder.freeRoomSchedule().withNextEventStartsIn(65).build()
        
        let result: [FreeTimeslot] = subject.calculateFreeTimeslotsIn(schedule)
        
        XCTAssertTrue(result.count == 2)
        XCTAssertEqual(result.last!.duration, FreeTimeslotDuration.halfAnHour)
        XCTAssertEqual(result.first!.duration, FreeTimeslotDuration.oneHour)
    }
    
    func testItReturnsThreeTimeslotIfRoomIsAvailableForMoreThanTwoHours() {
        let schedule = Builder.freeRoomSchedule().withNextEventStartsIn(125).build()
        
        let result: [FreeTimeslot] = subject.calculateFreeTimeslotsIn(schedule)
        
        XCTAssertTrue(result.count == 3)
        XCTAssertEqual(result[2].duration, FreeTimeslotDuration.halfAnHour)
        XCTAssertEqual(result[1].duration, FreeTimeslotDuration.oneHour)
        XCTAssertEqual(result[0].duration, FreeTimeslotDuration.twoHours)
    }
}
