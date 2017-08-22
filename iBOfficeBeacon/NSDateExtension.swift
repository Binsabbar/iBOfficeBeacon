//
//  NSDateComparasionExtension.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

extension Date {
    
    func isLaterThanDate(_ dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == .orderedDescending
    }
    
    func isTheSameDate(_ dateToCompare: Date ) -> Bool {
        return self.compare(dateToCompare) == .orderedSame
    }
    
    func isEarlierThanDate(_ dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == .orderedAscending
    }
    
    func compareDateToSecondPrecision(_ dateToCompare: Date) -> ComparisonResult {
        return (Calendar.current as NSCalendar).compare(self, to: dateToCompare,
                                                              toUnitGranularity: .second)
    }
    
    func compareDateToDayPrecision(_ dateToCompare: Date) -> ComparisonResult {
        return (Calendar.current as NSCalendar).compare(self, to: dateToCompare,
                                                        toUnitGranularity: .day)
    }
    
    func tomorrow() -> Date {
        var components = DateComponents()
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = (Calendar.current as NSCalendar).date(byAdding: components, to: self.beginningOfDay(), options: [])!
        return date
    }
    
    func beginningOfDayUTC() -> Date {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    func beginningOfDay() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    static func todayWithHours(_ houre: Int, andMinutes minutes: Int)-> Date {
        let date = Date()
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .timeZone], from: date)
        components.hour = houre % 24
        components.minute = minutes % 60
        return calendar.date(from: components)!
    }
    
    // I need a better solution, not happy with this.
    static func todayInUTC() -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return ((calendar as NSCalendar?)?.date(byAdding: componentsByAddingDay(0), to: Date(), options: []))!
    }
    
    static func tomorrowInUTC() -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return ((calendar as NSCalendar?)?.date(byAdding: componentsByAddingDay(1), to: Date(), options: []))!
    }
    
    fileprivate static func componentsByAddingDay(_ day: Int) -> DateComponents {
        var components = DateComponents()
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        return components
    }
}
