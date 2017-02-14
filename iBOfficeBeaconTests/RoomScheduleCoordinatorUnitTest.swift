//
//  RoomSchedulCoordinatorUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class RoomScheduleCoordinatorUnitTest: XCTestCase {
    
    var subject = RoomScheduleCoordinator()
    let eventTitle = "Unit testing"
    let now = NSDate()

    override func setUp() {
        super.setUp()
    }
    

    //MARK: Context: When there is one event
    //MARK: The event is now (current time is between event start and end time)
    func testItSetsRoomScheduleToBusyAndNextAvailableToCurrentEventEndTime() {
        let start = NSDate()
        let end = start.dateByAddingTimeInterval(oneHour)
        let events = [CalendarEvent(start: start, end: end, title: eventTitle)]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertTrue(result.isBusyNow)
        XCTAssertTrue(result.nextAvailable == end)
        XCTAssertTrue(result.currentEvent!.isEqualTo(events.first!))
    }

    //MARK: The event is in the past
    func testItSetsRoomScheduleToFreeWhenEventIsInThePast() {
        let start = NSDate().dateByAddingTimeInterval(pastHour * 2)
        let end = NSDate().dateByAddingTimeInterval(pastHour)
        
        let events = [CalendarEvent(start: start, end: end, title: eventTitle)]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertFalse(result.isBusyNow)
    }
    
    //MARK: The event is the future
    func testItSetsRoomScheduleToFreeForFutureEventAndTheMinutesTillNextEvent() {
        let start = NSDate().dateByAddingTimeInterval(oneHour)
        let end = start.dateByAddingTimeInterval(oneHour)
        
        let events = [CalendarEvent(start: start, end: end, title: eventTitle)]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        let minutesTillFree = ceil(start.timeIntervalSinceNow / 60)
        XCTAssertFalse(result.isBusyNow)
        XCTAssertTrue(result.minutesTillNextEvent == Int(minutesTillFree))
    }
    
    //MARK: Context: When there are two events
    //MARK: The 1st event is now, and both events are consecutive
    func testItSetsRoomScheduleToBusyAndNextAvailableToThEndOfLastConsecutiveEvent() {
        let start = NSDate()
        let end = start.dateByAddingTimeInterval(oneHour)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndEnd = end.dateByAddingTimeInterval(oneHour)
        let secondEvent = CalendarEvent(start: end, end: _2ndEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertTrue(result.isBusyNow)
        XCTAssertTrue(result.nextAvailable == _2ndEnd)
        XCTAssertTrue(result.currentEvent!.isEqualTo(firstEvent))
    }
    
    //MARK: The 1st event is now, and  events are NOT consecutive
    func testItSetsRoomScheduleToBusyAndNextAvailableToTheEndOfCurrentEvent() {
        let start = NSDate()
        let end = start.dateByAddingTimeInterval(oneHour)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndStart = end.dateByAddingTimeInterval(oneHour)
        let _2ndEnd = _2ndStart.dateByAddingTimeInterval(oneHour)
        let secondEvent = CalendarEvent(start: _2ndStart, end: _2ndEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertTrue(result.isBusyNow)
        XCTAssertTrue(result.nextAvailable == end)
    }
    
    //MARK: Both events are in the future
    func testItSetsRoomScheduleToFreeAndMinutesTillNextEventToStartOfNextEvent() {
        let start = NSDate().dateByAddingTimeInterval(oneHour)
        let end = start.dateByAddingTimeInterval(oneHour)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndEnd = end.dateByAddingTimeInterval(oneHour)
        let secondEvent = CalendarEvent(start: end, end: _2ndEnd, title: eventTitle)
        let events = [firstEvent, secondEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        let minutesTillFree = ceil(start.timeIntervalSinceNow / 60)
        XCTAssertFalse(result.isBusyNow)
        XCTAssertTrue(result.minutesTillNextEvent == Int(minutesTillFree))
    }
    
    //MARK: Both events are in the past
    func testItSetsRoomScheduleToFreeWhenAllEventsAreInThePast() {
        let start = now.dateByAddingTimeInterval(pastHour * 3)
        let end = now.dateByAddingTimeInterval(pastHour * 2)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndEnd = now.dateByAddingTimeInterval(pastHour)
        let secondEvent = CalendarEvent(start: end, end: _2ndEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertFalse(result.isBusyNow)
    }
    
    //MARK: The 1st event is in the past, and 2nd event in the future
    func testItSetsRoomScheduleToFreeWhenCurrentTimeLiesBetweenPastAndFutureEvents() {
        let start = now.dateByAddingTimeInterval(pastHour * 3)
        let end = now.dateByAddingTimeInterval(pastHour * 2)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndStart = now.dateByAddingTimeInterval(oneHour)
        let _2ndEnd = _2ndStart.dateByAddingTimeInterval(oneHour)
        let secondEvent = CalendarEvent(start: _2ndStart, end: _2ndEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        let minutesTillFree = ceil(_2ndStart.timeIntervalSinceNow / 60)
        XCTAssertFalse(result.isBusyNow)
        XCTAssertTrue(result.minutesTillNextEvent == Int(minutesTillFree))
    }
    
    //MARK: Context - Where there are more than two events ( 3 or more)
    //MARK: all events are consecutive, and 1st event is now
    func testItSetsRoomScheduleToBusyAndNextAvailableToTheEndOfLastConsecutiveEventV1() {
        let start =  NSDate()
        let end = start.dateByAddingTimeInterval(oneHour)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndEnd = end.dateByAddingTimeInterval(oneHour)
        let secondEvent = CalendarEvent(start: end, end: _2ndEnd, title: eventTitle)
        
        let _3rdEnd = _2ndEnd.dateByAddingTimeInterval(oneHour)
        let thirdEvent = CalendarEvent(start: _2ndEnd, end: _3rdEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent, thirdEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertTrue(result.isBusyNow)
        XCTAssertTrue(result.nextAvailable == _3rdEnd)
        XCTAssertTrue(result.currentEvent!.isEqualTo(firstEvent))
    }
    
    //MARK: 1st and 2nd are consecutive, and now, but 3rd is future
    func testItSetsRoomScheduleToBusyAndNextAvailableToTheEndOfLastConsecutiveEventV2() {
        let start =  NSDate()
        let end = start.dateByAddingTimeInterval(oneHour)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndEnd = end.dateByAddingTimeInterval(oneHour)
        let secondEvent = CalendarEvent(start: end, end: _2ndEnd, title: eventTitle)
        
        let _3rdStart = _2ndEnd.dateByAddingTimeInterval(oneHour)
        let _3rdEnd = _3rdStart.dateByAddingTimeInterval(oneHour)
        let thirdEvent = CalendarEvent(start: _3rdStart, end: _3rdEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent, thirdEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertTrue(result.isBusyNow)
        XCTAssertTrue(result.nextAvailable == _2ndEnd)
    }
    
    //MARK: The 1st event is in the past, 2nd is now, and 3rd is consecutive event to 2nd
    func testItSetsRoomScheduleToBusyAndNextAvailableToTheEndOfLastConsecutiveEventV3() {
        let start = now.dateByAddingTimeInterval(past2Hours)
        let end = now.dateByAddingTimeInterval(pastHour)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndEnd = now.dateByAddingTimeInterval(oneHour)
        let secondEvent = CalendarEvent(start: now, end: _2ndEnd, title: eventTitle)
        
        let _3rdEnd = _2ndEnd.dateByAddingTimeInterval(oneHour)
        let thirdEvent = CalendarEvent(start: _2ndEnd, end: _3rdEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent, thirdEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertTrue(result.isBusyNow)
        XCTAssertTrue(result.nextAvailable == _3rdEnd)
        XCTAssertTrue(result.currentEvent!.isEqualTo(secondEvent))
    }
    
    //MARK: 1st and 2nd in the past, but 3rd is now and consecutive to 2nd
    func testItSetsRoomScheduleToBusyAndNextAvailableToTheEndOfLastConsecutiveEventV4() {
        let start = now.dateByAddingTimeInterval(pastHour*2)
        let end = now.dateByAddingTimeInterval(pastHour)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndEnd = now.dateByAddingTimeInterval(halfAnHour * -1)
        let secondEvent = CalendarEvent(start: end, end: _2ndEnd, title: eventTitle)
        
        let _3rdEnd = _2ndEnd.dateByAddingTimeInterval(oneHour)
        let thirdEvent = CalendarEvent(start: _2ndEnd, end: _3rdEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent, thirdEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        
        XCTAssertTrue(result.isBusyNow)
        XCTAssertTrue(result.nextAvailable == _3rdEnd)
        XCTAssertTrue(result.currentEvent!.isEqualTo(thirdEvent))
    }
    
    //MARK: 1st and 2nd in the past, but 3rd is future
    func testItSetsRoomScheduleToFreeWhenNoEventsIsCurrent() {
        let start = now.dateByAddingTimeInterval(pastHour*2)
        let end = now.dateByAddingTimeInterval(pastHour)
        let firstEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let _2ndEnd = now.dateByAddingTimeInterval(halfAnHour * -1)
        let secondEvent = CalendarEvent(start: end, end: _2ndEnd, title: eventTitle)
        
        let _3rdStart = now.dateByAddingTimeInterval(oneHour)
        let _3rdEnd = _3rdStart.dateByAddingTimeInterval(oneHour)
        let thirdEvent = CalendarEvent(start: _3rdStart, end: _3rdEnd, title: eventTitle)
        
        let events = [firstEvent, secondEvent, thirdEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events)
        let minutesTill3rdEvent = ceil(_3rdStart.timeIntervalSinceNow / 60)
        XCTAssertFalse(result.isBusyNow)
        XCTAssertTrue(result.minutesTillNextEvent == Int(minutesTill3rdEvent))
    }
    
    // MARK: Set available time for booking 30 minnutes, 1 Hour and 2 Hours
    func testItSetsThreeAvailableTimeslotWhenRoomIsFreeForMoreThan2Hours() {
        let start = now.dateByAddingTimeInterval(3*oneHour)
        let end = start.dateByAddingTimeInterval(3*oneHour)
        let futureEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let events = [futureEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events).availableTimeSlots
        
        
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
        XCTAssertTrue(result.contains{$0.duration == .oneHour})
        XCTAssertTrue(result.contains{$0.duration == .twoHours})
    }
    
    // MARK: Set available time for booking 30 minnutes, 1 Hour
    func testItSetsTwoAvailableTimeslotWhenRoomIsFreeForOneHourButNotMoreThanTwo() {
        let secondsTillNextEvent: Double = halfAnHour * 3
        let start = now.dateByAddingTimeInterval(secondsTillNextEvent)
        let end = start.dateByAddingTimeInterval(oneHour)
        let futureEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let events = [futureEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events).availableTimeSlots
        
        XCTAssertTrue(result.count == 2)
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
        XCTAssertTrue(result.contains{$0.duration == .oneHour})
    }
    
    // MARK: Set available time for booking 30 minnutes, 1 Hour
    func testItSetsAvailableTimeslotToHalfAnHourSlotWhenRoomIsFreeForLessThanOneHour() {
        let secondsTillNextEvent: Double = 60 * 50
        let start = now.dateByAddingTimeInterval(secondsTillNextEvent)
        let end = start.dateByAddingTimeInterval(oneHour)
        let futureEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let events = [futureEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events).availableTimeSlots
        
        XCTAssertTrue(result.count == 1)
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
    }
    
    // MARK: Set available time for booking 30 minnutes
    func testItSetsAvailableTimeslotToHalfAnHourSlotWhenRoomIsFreeForHalfAnHour() {
        let start = now.dateByAddingTimeInterval(halfAnHour)
        let end = start.dateByAddingTimeInterval(oneHour)
        let futureEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let events = [futureEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events).availableTimeSlots
        
        XCTAssertTrue(result.count == 1)
        XCTAssertTrue(result.contains{$0.duration == .halfAnHour})
    }
    
    // MARK: Set available time for booking whatever remaining
    func testItSetsAvailableTimeslotToLessThanHalfIfRoomIsFreeForLessThanHalfAnHour() {
        let minutesTillNextEvent = 25
        let secondsTillNextEvent = Double(60 * minutesTillNextEvent)
        let start = now.dateByAddingTimeInterval(secondsTillNextEvent)
        let end = start.dateByAddingTimeInterval(oneHour)
        let futureEvent = CalendarEvent(start: start, end: end, title: eventTitle)
        
        let events = [futureEvent]
        
        let result = subject.findCurrentRoomScheduleFromEvents(events).availableTimeSlots
        
        XCTAssertTrue(result.count == 1)
        XCTAssertTrue(result.contains{$0.duration == .lessThanHalfAnHour(minutes: minutesTillNextEvent)})
    }
}
