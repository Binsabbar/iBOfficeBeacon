//
//  RoomScheduleViewModel.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 27/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class RoomScheduleViewModel {
    
    let model: RoomSchedule
    let room: OfficeRoom
    
    init(model: RoomSchedule, room: OfficeRoom) {
        self.model = model
        self.room = room
    }
    
    var shouldHideBookButton: Bool {
        return model.isBusyNow || room.calendarID.isEmpty
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
        return model.isBusyNow ? AppColours.darkRed:AppColours.darkGreen
    }
    
    var gradientViewMiddleColor: UIColor {
        return model.isBusyNow ? AppColours.mediumRed:AppColours.mediumGreen
    }
    
    var gradientViewBottomColor: UIColor {
        return model.isBusyNow ? AppColours.lightRed:AppColours.lightGreen
    }

    var scheduleTimeInfoBackgroundColor: UIColor {
        return UIColor.clearColor()
    }
    
    var statusLabelTitle: String {
        return model.isBusyNow ? "Room is busy":"Room is free"
    }
    
    var statusLabelBackgroundColor: UIColor {
        return model.isBusyNow ? AppColours.red:AppColours.green
    }
    
    var scheduleLabelTitle: String {
        if model.isBusyNow,
        let event = model.currentEvent {
            return event.title as String
        }
        return ""
    }
    
    var scheduleTimeInfoAttributedString: NSAttributedString {
        let attrs = [NSFontAttributeName: UIFont.boldSystemFontOfSize(30),
                     NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attributedText = NSMutableAttributedString()
        if model.isBusyNow {
            if let event = model.currentEvent where event.isAllDayEvent() {
                attributedText.appendAttributedString(NSAttributedString(string: "Booked all day"))
            } else if let date = model.nextAvailable {
                attributedText.appendAttributedString(NSAttributedString(string: "Booked until\n\n"))
                attributedText.appendAttributedString(NSAttributedString(string: dateToString(date), attributes: attrs))
            }
            
        } else if let minutes = model.minutesTillNextEvent {
            let date = minutesToDate(minutes)
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
