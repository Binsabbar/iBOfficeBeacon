//
//  FreeTimeslotCalculator.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

class FreeTimeslotCalculator {
    
    typealias Duration = FreeTimeslotDuration
    func calculateFreeTimeslotsIn(schedule: RoomSchedule) -> [FreeTimeslot]{
        var timeslots = [FreeTimeslot]()
        
        if !schedule.isBusyNow {
            let minuteSlot = 30
            var availableMinutes = schedule.minutesTillNextEvent!
            
            if availableMinutes < 30 {
                let start = NSDate()
                let doubleMinutes = Double(availableMinutes)
                let end = start.dateByAddingTimeInterval(doubleMinutes * 60)
                let timeslot = FreeTimeslot(duration: .lessThanHalfAnHour(minutes: availableMinutes),
                                            from: start, to: end)
                timeslots.append(timeslot)
            }
            
            if availableMinutes >= Duration.halfAnHour.minutes() {
                let start = NSDate()
                let end = start.dateByAddingTimeInterval(30 * 60)
                let timeslot = FreeTimeslot(duration: .halfAnHour, from: start, to: end)
                timeslots.append(timeslot)
            }
            
            availableMinutes = availableMinutes - (2 * minuteSlot)
            if availableMinutes > 0 {
                let start = NSDate()
                let end = start.dateByAddingTimeInterval(60 * 60)
                let timeslot = FreeTimeslot(duration: .oneHour, from: start, to: end)
                timeslots.append(timeslot)
            }
            
            availableMinutes = availableMinutes - (2 * minuteSlot)
            if availableMinutes > 0 {
                let start = NSDate()
                let end = start.dateByAddingTimeInterval(120 * 60)
                let timeslot = FreeTimeslot(duration: .twoHours, from: start, to: end)
                timeslots.append(timeslot)
            }
        }
        
        
        return timeslots
    }
}
