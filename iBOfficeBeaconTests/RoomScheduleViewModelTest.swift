//
//  RoomScheduleViewModelTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class RoomScheduleViewModelTest: XCTestCase {

    var subject: RoomScheduleViewModel!
    var anyRoom = OfficeRoom(withName: "aynRoom", calendarID: "anyroom", minor: 9)
    
    func testItSetsTheViewModelForBusyRoomSchedule() {
        let busySchedule = createBusySchedule()

        let expectedDetails = "Booked until\n\n\(dateToString(busySchedule.nextAvailable))"
        
        subject = RoomScheduleViewModel(model: busySchedule, room: anyRoom)
        
        XCTAssertTrue(subject.shouldHideBookButton)
        XCTAssertTrue(subject.statusLabelBackgroundColor.isEqual(AppColours.red))
        XCTAssertTrue(isString(firstString: subject.statusLabelTitle, equalsToOtherString: "Room is busy", ignoreCase: false))
        XCTAssertTrue(subject.scheduleLabelTitle == busySchedule.currentEvent.title)
        XCTAssertTrue(isString(firstString: subject.scheduleTimeInfoAttributedString.string, equalsToOtherString: expectedDetails, ignoreCase: true))
    }
    
    func testItSetsGradientRedColorsForBusySchedule() {
        let busySchedule = createBusySchedule()
        
        subject = RoomScheduleViewModel(model: busySchedule, room: anyRoom)
        
        XCTAssertTrue(subject.gradientViewTopColor.isEqual(AppColours.darkRed))
        XCTAssertTrue(subject.gradientViewMiddleColor.isEqual(AppColours.mediumRed))
        XCTAssertTrue(subject.gradientViewBottomColor.isEqual(AppColours.lightRed))
    }
    
    
    func testItSetsTheViewModelForFreeRoomSchedule() {
        let availableForInMinutes = 60
        let timeIntervalInSeconds = NSTimeInterval(60 * availableForInMinutes)
        let availableForAsDate = NSDate().dateByAddingTimeInterval(timeIntervalInSeconds)
        
        let freeSchedule = createFreeScheduleWithFreeTill(availableForInMinutes)
        
        let expectedDetails = "Free until\n\n\(dateToString(availableForAsDate))"
        
        subject = RoomScheduleViewModel(model: freeSchedule, room: anyRoom)
        
        XCTAssertFalse(subject.shouldHideBookButton)
        
        XCTAssertTrue(subject.bookButtonBackgroundColor.isEqual(AppColours.mediumGreen))
        XCTAssertTrue(subject.statusLabelBackgroundColor.isEqual(AppColours.green))
        
        XCTAssertTrue(isString(firstString: subject.statusLabelTitle, equalsToOtherString: "Room is free", ignoreCase: false))
        XCTAssertTrue(subject.scheduleLabelTitle == "")
        XCTAssertTrue(isString(firstString: subject.scheduleTimeInfoAttributedString.string, equalsToOtherString: expectedDetails, ignoreCase: true))
    }
    
    func testItSetsGradientGreenColorsForFreeSchedule() {
        let freeSchedule = createFreeScheduleWithFreeTill(90)
        
        subject = RoomScheduleViewModel(model: freeSchedule, room: anyRoom)
        
        XCTAssertTrue(subject.gradientViewTopColor.isEqual(AppColours.darkGreen))
        XCTAssertTrue(subject.gradientViewMiddleColor.isEqual(AppColours.mediumGreen))
        XCTAssertTrue(subject.gradientViewBottomColor.isEqual(AppColours.lightGreen))
    }
    
    func testItDoesNotDisplayNextEventForAllDayEvent() {
        let busySchedule = createBusyScheduleWithAllDayEvent()
        
        let expectedDetails = "Booked all day"
        
        subject = RoomScheduleViewModel(model: busySchedule, room: anyRoom)
        
        XCTAssertTrue(subject.shouldHideBookButton)
        XCTAssertTrue(subject.statusLabelBackgroundColor.isEqual(AppColours.red))
        XCTAssertTrue(isString(firstString: subject.statusLabelTitle, equalsToOtherString: "Room is busy", ignoreCase: false))
        XCTAssertTrue(subject.scheduleLabelTitle == busySchedule.currentEvent.title)
        XCTAssertTrue(isString(firstString: subject.scheduleTimeInfoAttributedString.string, equalsToOtherString: expectedDetails, ignoreCase: true))
    }
    

    func testItDoesNotDisplayBookButtonIfRoomDoesNotHaveCalendarID() {
        let roomWithoutCalendarID = OfficeRoom(withName: "random", calendarID: "", minor: 3)
        let schedule = createFreeScheduleWithFreeTill(120)
        
        let model = RoomScheduleViewModel(model: schedule, room: roomWithoutCalendarID)
        
        XCTAssertTrue(model.shouldHideBookButton)
    }
    
    private func createBusyScheduleWithAllDayEvent() -> BusySchedule {
        let start = NSDate().beginningOfDay()
        let end = start.tomorrow()
        let currentEvent = CalendarEvent(start: start, end: end, title: "Testing RoomScheduleVM")
        return BusySchedule(with: currentEvent, nextAvailable: end)
    }
    
    private func createFreeScheduleWithFreeTill(minutes: Int) -> FreeSchedule {
        return FreeSchedule(for: minutes, with: Set())
    }
    
    private func createBusySchedule() -> BusySchedule {
        let scheduleEndsAt = NSDate().dateByAddingTimeInterval(oneHour)
        let event = CalendarEvent(start: NSDate(), end: NSDate(), title: "Testing RoomScheduleVM")
        return BusySchedule(with: event, nextAvailable: scheduleEndsAt)
    }
    
    private func dateToString(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        
        return String(format: "%02d:%02d", components.hour, components.minute)
    }

}
