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
    
    
    func calculateFreeTimeslotsFrom(minutes: Int) -> Set<FreeTimeslot>{
        if minutes > 0{
            return buildTimeslots(from: minutes)
        }
        return Set<FreeTimeslot>()
    }
    
    fileprivate func buildTimeslots(from availableTime: Int) -> Set<FreeTimeslot> {
        let timeSlots: Set<FreeTimeslot>
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
    
    fileprivate func makeTimelotsFrom(_ durations: [Duration]) -> Set<FreeTimeslot> {
        let start = Date()
        var timeSlots = Set<FreeTimeslot>()
        durations.forEach({
            let end = start.addingTimeInterval(Double($0.minutes() * 60))
            let timeSlot = FreeTimeslot(duration: $0, from: start, to: end)
            timeSlots.insert(timeSlot)
        })
        return timeSlots
    }
}
