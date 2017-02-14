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
        let result: Set<FreeTimeslot> = subject.calculateFreeTimeslotsFrom(minutes: 23)
        
        XCTAssertTrue(result.count == 1)
        XCTAssertTrue(result.contains{$0.duration == .lessThanHalfAnHour(minutes: 23)})

    }
    
    func testItReturnsHalfAnHourTimeslot() {
        let result: Set<FreeTimeslot> = subject.calculateFreeTimeslotsFrom(minutes: 35)
        
        XCTAssertTrue(result.count == 1)
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
    }
    
    
    func testItReturnsTwoTimeslotIfRoomIsAvailableForMoreThanOneHour() {
        let result: Set<FreeTimeslot> = subject.calculateFreeTimeslotsFrom(minutes: 90)

        
        XCTAssertTrue(result.count == 2)
        
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
        XCTAssertTrue(result.contains{$0.duration == .oneHour})
    }
    
    func testItReturnsThreeTimeslotIfRoomIsAvailableForMoreThanTwoHours() {
        let result: Set<FreeTimeslot> = subject.calculateFreeTimeslotsFrom(minutes: 122)

        
        XCTAssertTrue(result.count == 3)
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
        XCTAssertTrue(result.contains{$0.duration == .oneHour})
        XCTAssertTrue(result.contains{$0.duration == .twoHours})
    }
}
