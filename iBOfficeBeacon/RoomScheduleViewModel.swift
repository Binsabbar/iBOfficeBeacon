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
        return UIColor.clear
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
        return UIColor.clear
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
        let attrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30),
                     NSForegroundColorAttributeName: UIColor.white]
        let attributedText = NSMutableAttributedString()
        if let model = model as? BusySchedule {
            if model.currentEvent.isAllDayEvent() {
                attributedText.append(NSAttributedString(string: "Booked all day"))
            } else {
                let date = model.nextAvailable
                attributedText.append(NSAttributedString(string: "Booked until\n\n"))
                attributedText.append(NSAttributedString(string: dateToString(date as Date), attributes: attrs))
            }
            
        } else {
            let date = minutesToDate(model.minutesTillNextEvent)
            attributedText.append(NSAttributedString(string: "Free until\n\n"))
            attributedText.append(NSAttributedString(string: dateToString(date), attributes: attrs))
        }
        return attributedText
    }
    
    fileprivate func minutesToDate(_ minutes: Int) -> Date {
        let minutesAsTimeInterval = TimeInterval(60 * minutes)
        return Date().addingTimeInterval(minutesAsTimeInterval)
    }
    
    fileprivate func dateToString(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute], from: date)
        
        return String(format: "%02d:%02d", components.hour!, components.minute!)
    }
}
