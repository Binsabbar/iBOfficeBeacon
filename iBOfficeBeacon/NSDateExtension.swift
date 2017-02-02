//
//  NSDateComparasionExtension.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

extension NSDate {
    
    func isLaterThanDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare) == .OrderedDescending
    }
    
    func isTheSameDate(dateToCompare: NSDate ) -> Bool {
        return self.compare(dateToCompare) == .OrderedSame
    }
    
    func isEarlierThanDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare) == .OrderedAscending
    }
    
    func compareDateToSecondPrecision(dateToCompare: NSDate) -> NSComparisonResult {
        return NSCalendar.currentCalendar().compareDate(self, toDate: dateToCompare,
                                                              toUnitGranularity: .Second)
    }
    
    func compareDateToDayPrecision(dateToCompare: NSDate) -> NSComparisonResult {
        return NSCalendar.currentCalendar().compareDate(self, toDate: dateToCompare,
                                                        toUnitGranularity: .Day)
    }
    
    func tomorrow() -> NSDate {
        let components = NSDateComponents()
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.beginningOfDay(), options: [])!
        return date
    }
    
    func beginningOfDayUTC() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
        let components = calendar.components([.Year, .Month, .Day], fromDate: self)
        return calendar.dateFromComponents(components)!
    }
    
    func beginningOfDay() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: self)
        return calendar.dateFromComponents(components)!
    }
    
    static func todayWithHours(houre: Int, andMinutes minutes: Int)-> NSDate {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .TimeZone], fromDate: date)
        components.hour = houre % 24
        components.minute = minutes % 60
        return calendar.dateFromComponents(components)!
    }
    
    // I need a better solution, not happy with this.
    static func todayInUTC() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        return (calendar?.dateByAddingComponents(componentsByAddingDay(0), toDate: NSDate(), options: []))!
    }
    
    static func tomorrowInUTC() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        return (calendar?.dateByAddingComponents(componentsByAddingDay(1), toDate: NSDate(), options: []))!
    }
    
    private static func componentsByAddingDay(day: Int) -> NSDateComponents {
        let components = NSDateComponents()
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        return components
    }
}
