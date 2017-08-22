//
//  CalendarService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class CalendarService: NSObject {
    
    typealias onFoundScheduleHandler = (ScheduleProtocol?) -> Void
    
    let calendarClient: CalendarClient
    let eventProcessor: CalendarEventsProcessor
    let coordinator: RoomScheduleCoordinator
    let dateFormatter = DateFormatter()
    
    var handler: onFoundScheduleHandler?
    
    init(calendarClient: CalendarClient, eventProcessor: CalendarEventsProcessor,
         coordinator: RoomScheduleCoordinator) {
        self.calendarClient = calendarClient
        self.eventProcessor = eventProcessor
        self.coordinator = coordinator
        super.init()
    }
    
    func findScheduleForRoom(_ room: OfficeRoom, onFoundHandler handler: @escaping onFoundScheduleHandler) {
        self.handler = handler
        calendarClient.fetchEventsForCalendarWithID(room.calendarID, onFetched:
            { events in
                let processedEvents = self.eventProcessor.processEvents(events, forCalendarWithID: room.calendarID)
                let schedule = self.coordinator.findCurrentRoomScheduleFromEvents(processedEvents)
                self.handler?(schedule)
            },
            onFailur: {error in
                // display an alert
            })
    }
    
    typealias BookRoomCallBack = (Bool)->Void
    func bookRoomAsync(_ room: OfficeRoom, withSchedule schedule: ScheduleProtocol, onCompeletion: @escaping BookRoomCallBack) {
        let endTime = calculateEndTimeForNewEventFromSchedule(schedule)
        let event = eventProcessor.eventStartsAt(Date(), endsAt: endTime, includesAttendees: [room.calendarID])
        calendarClient.insertEventAsync(event, onCompeletion: onCompeletion)
    }
    
    fileprivate func calculateEndTimeForNewEventFromSchedule(_ schedule: ScheduleProtocol) -> Date {
        let maxMinutesForBookingEvent = 30
        var eventLength = 30
        if schedule.minutesTillNextEvent < maxMinutesForBookingEvent {
            eventLength = schedule.minutesTillNextEvent - 1
        }
        return Date().addingTimeInterval(Double(eventLength * 60))
    }
}
