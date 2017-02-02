//
//  CalendarService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class CalendarService: NSObject {
    
    typealias onFoundScheduleHanlder = (RoomSchedule?) -> Void
    
    let calendarClient: CalendarClient
    let eventProcessor: CalendarEventsProcessor
    let coordinator: RoomScheduleCoordinator
    let dateFormatter = NSDateFormatter()
    
    var handler: onFoundScheduleHanlder?
    
    init(calendarClient: CalendarClient, eventProcessor: CalendarEventsProcessor,
         coordinator: RoomScheduleCoordinator) {
        self.calendarClient = calendarClient
        self.eventProcessor = eventProcessor
        self.coordinator = coordinator
        super.init()
    }
    
    func findScheduleForRoom(room: OfficeRoom, onFoundHandler handler: onFoundScheduleHanlder) {
        self.handler = handler
        calendarClient.fetchEventsForCalendarWithID(room.calendarID, onFetched:
            { events in
                let processedEvents = self.eventProcessor.processEvents(events, forCalendarWithID: room.calendarID)
                let schedule = self.coordinator.findCurrentRoomScheduleFromEvents(processedEvents)
                self.handler?(schedule)
            },
            onFailur: {error in
                self.handler?(RoomSchedule())
            })
    }
    
    typealias BookRoomCallBack = (Bool)->Void
    func bookRoomAsync(room: OfficeRoom, withSchedule schedule: RoomSchedule, onCompeletion: BookRoomCallBack) {
        let endTime = calculateEndTimeForNewEventFromSchedule(schedule)
        let event = eventProcessor.eventStartsAt(NSDate(), endsAt: endTime, includesAttendees: [room.calendarID])
        calendarClient.insertEventAsync(event, onCompeletion: onCompeletion)
    }
    
    private func calculateEndTimeForNewEventFromSchedule(schedule: RoomSchedule) -> NSDate {
        let maxMinutesForBookingEvent = 30
        var eventLength = 30
        if let minutes = schedule.minutesTillNextEvent {
            if minutes < maxMinutesForBookingEvent {
                eventLength = minutes - 1
            }
        }
        
        return NSDate().dateByAddingTimeInterval(Double(eventLength * 60))
    }
}
