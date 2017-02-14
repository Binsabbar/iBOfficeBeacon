//
//  RoomScheduleViewModel.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class RoomScheduleViewModel {
    
    let model: ScheduleProtocol
    let room: OfficeRoom
    
    init(model: ScheduleProtocol, room: OfficeRoom) {
        self.model = model
        self.room = room
    }
    
    var shouldHideBookButton: Bool {
        return model.isBusy || room.calendarID.isEmpty
    }
    
    var bookButtonBackgroundColor: UIColor {
        return AppColours.mediumGreen
    }
    
    var bookButtonColorForNormalState: UIColor {
        return UIColor.clearColor()
    }
    
    var bookButtonColorForTapState: UIColor {
        return AppColours.darkBlue
    }

    var gradientViewTopColor: UIColor {
        return model.isBusy ? AppColours.darkRed:AppColours.darkGreen
    }
    
    var gradientViewMiddleColor: UIColor {
        return model.isBusy ? AppColours.mediumRed:AppColours.mediumGreen
    }
    
    var gradientViewBottomColor: UIColor {
        return model.isBusy ? AppColours.lightRed:AppColours.lightGreen
    }

    var scheduleTimeInfoBackgroundColor: UIColor {
        return UIColor.clearColor()
    }
    
    var statusLabelTitle: String {
        return model.isBusy ? "Room is busy":"Room is free"
    }
    
    var statusLabelBackgroundColor: UIColor {
        return model.isBusy ? AppColours.red:AppColours.green
    }
    
    var scheduleLabelTitle: String {
        if let busySchedule = model as? BusySchedule {
            return busySchedule.currentEvent.title as String
        }
        return ""
    }
    
    var scheduleTimeInfoAttributedString: NSAttributedString {
        let attrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(30),
                     NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attributedText = NSMutableAttributedString()
        if let model = model as? BusySchedule {
            if model.currentEvent.isAllDayEvent() {
                attributedText.appendAttributedString(NSAttributedString(string: "Booked all day"))
            } else {
                let date = model.nextAvailable
                attributedText.appendAttributedString(NSAttributedString(string: "Booked until\n\n"))
                attributedText.appendAttributedString(NSAttributedString(string: dateToString(date), attributes: attrs))
            }
            
        } else {
            let date = minutesToDate(model.minutesTillNextEvent)
            attributedText.appendAttributedString(NSAttributedString(string: "Free until\n\n"))
            attributedText.appendAttributedString(NSAttributedString(string: dateToString(date), attributes: attrs))
        }
        return attributedText
    }
    
    private func minutesToDate(minutes: Int) -> NSDate {
        let minutesAsTimeInterval = NSTimeInterval(60 * minutes)
        return NSDate().dateByAddingTimeInterval(minutesAsTimeInterval)
    }
    
    private func dateToString(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        
        return String(format: "%02d:%02d", components.hour, components.minute)
    }
}
