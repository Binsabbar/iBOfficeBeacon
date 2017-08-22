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

        let expectedDetails = "Booked until\n\n\(dateToString(busySchedule.nextAvailable as Date))"
        
        subject = RoomScheduleViewModel(model: busySchedule, room: anyRoom)
        
        XCTAssertTrue(subject.shouldHideBookButton)
        XCTAssertTrue(subject.statusLabelBackgroundColor.isEqual(AppColours.red))
        XCTAssertTrue(isString(firstString: subject.statusLabelTitle, equalsToOtherString: "Room is busy", ignoreCase: false))
        XCTAssertTrue(subject.scheduleLabelTitle == busySchedule.currentEvent.title as String)
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
        let timeIntervalInSeconds = TimeInterval(60 * availableForInMinutes)
        let availableForAsDate = Date().addingTimeInterval(timeIntervalInSeconds)
        
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
        XCTAssertTrue(subject.scheduleLabelTitle == busySchedule.currentEvent.title as String)
        XCTAssertTrue(isString(firstString: subject.scheduleTimeInfoAttributedString.string, equalsToOtherString: expectedDetails, ignoreCase: true))
    }
    

    func testItDoesNotDisplayBookButtonIfRoomDoesNotHaveCalendarID() {
        let roomWithoutCalendarID = OfficeRoom(withName: "random", calendarID: "", minor: 3)
        let schedule = createFreeScheduleWithFreeTill(120)
        
        let model = RoomScheduleViewModel(model: schedule, room: roomWithoutCalendarID)
        
        XCTAssertTrue(model.shouldHideBookButton)
    }
    
    fileprivate func createBusyScheduleWithAllDayEvent() -> BusySchedule {
        let start = Date().beginningOfDay()
        let end = start.tomorrow()
        let currentEvent = CalendarEvent(start: start, end: end, title: "Testing RoomScheduleVM")
        return BusySchedule(with: currentEvent, nextAvailable: end)
    }
    
    fileprivate func createFreeScheduleWithFreeTill(_ minutes: Int) -> FreeSchedule {
        return FreeSchedule(for: minutes, with: Set())
    }
    
    fileprivate func createBusySchedule() -> BusySchedule {
        let scheduleEndsAt = Date().addingTimeInterval(oneHour)
        let event = CalendarEvent(start: Date(), end: Date(), title: "Testing RoomScheduleVM")
        return BusySchedule(with: event, nextAvailable: scheduleEndsAt)
    }
    
    fileprivate func dateToString(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute], from: date)
        
        return String(format: "%02d:%02d", components.hour!, components.minute!)
    }

}
