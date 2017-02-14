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
        
        let result: Set<FreeTimeslot> = subject.calculateFreeTimeslotsIn(schedule)
        
        XCTAssertTrue(result.count == 1)
        XCTAssertTrue(result.contains{$0.duration == .lessThanHalfAnHour(minutes: 29)})

    }
    
    func testItReturnsHalfAnHourTimeslot() {
        let schedule = Builder.freeRoomSchedule().withNextEventStartsIn(35).build()
        
        let result: Set<FreeTimeslot> = subject.calculateFreeTimeslotsIn(schedule)
        
        XCTAssertTrue(result.count == 1)
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
    }
    
    
    func testItReturnsTwoTimeslotIfRoomIsAvailableForMoreThanOneHour() {
        let schedule = Builder.freeRoomSchedule().withNextEventStartsIn(65).build()
        
        let result: Set<FreeTimeslot> = subject.calculateFreeTimeslotsIn(schedule)
        
        XCTAssertTrue(result.count == 2)
        
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
        XCTAssertTrue(result.contains{$0.duration == .oneHour})
    }
    
    func testItReturnsThreeTimeslotIfRoomIsAvailableForMoreThanTwoHours() {
        let schedule = Builder.freeRoomSchedule().withNextEventStartsIn(125).build()
        
        let result: Set<FreeTimeslot> = subject.calculateFreeTimeslotsIn(schedule)
        
        XCTAssertTrue(result.count == 3)
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
        XCTAssertTrue(result.contains{$0.duration == .oneHour})
        XCTAssertTrue(result.contains{$0.duration == .twoHours})
    }
}
