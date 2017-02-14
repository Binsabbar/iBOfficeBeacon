//
//  FreeTimeslotCalculator.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/01/2017.
//  Copyright © 2017 Binsabbar. All rights reserved.
//

import Foundation

class FreeTimeslotCalculator {
    
    let TWO_HOURS = Double(Duration.twoHours.minutes())
    let HALF_AN_HOUR = Double(Duration.halfAnHour.minutes())
    
    typealias Duration = FreeTimeslotDuration
    
    func calculateFreeTimeslotsIn(schedule: RoomSchedule) -> [FreeTimeslot]{
        if !schedule.isBusyNow {
            return buildTimeslots(from: schedule.minutesTillNextEvent!)
        }
        return [FreeTimeslot]()
    }
    
    private func buildTimeslots(from availableTime: Int) -> [FreeTimeslot] {
        let timeSlots: [FreeTimeslot]
        var durations = [Duration]()
        
        switch true {
            case availableTime >= Duration.twoHours.minutes():
                durations = [.twoHours, .oneHour, .halfAnHour]
                timeSlots = makeTimelotsFrom(durations)
                break
            case availableTime >= Duration.oneHour.minutes():
                durations = [.oneHour, .halfAnHour]
                timeSlots = makeTimelotsFrom(durations)
            break
            case availableTime >= Duration.halfAnHour.minutes():
                durations = [.halfAnHour]
                timeSlots = makeTimelotsFrom(durations)
            break
            default:
                durations = [.lessThanHalfAnHour(minutes: availableTime)]
                timeSlots = makeTimelotsFrom(durations)
                break
        }
        
        return timeSlots
    }
    
    private func makeTimelotsFrom(durations: [Duration]) -> [FreeTimeslot] {
        let start = NSDate()
        var timeSlots = [FreeTimeslot]()
        durations.forEach({
            let end = start.dateByAddingTimeInterval(Double($0.minutes() * 60))
            let timeSlot = FreeTimeslot(duration: $0, from: start, to: end)
            timeSlots.append(timeSlot)
        })
        return timeSlots
    }
}
