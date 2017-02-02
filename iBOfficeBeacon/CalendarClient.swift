//
//  CalendarClient.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 12/03/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class CalendarClient: NSObject {
 
    typealias OnFetchedHandler = (GTLRCalendar_Events)->Void
    typealias onFailHandler = (NSError)->Void
    
    let service: GTLRCalendarService
    let errorHandler: ErrorHandlingProtocol
    
    init(withGoogleService service: GTLRCalendarService, errorHandler: ErrorHandlingProtocol) {
        self.service = service
        self.errorHandler = errorHandler
    }
    
    func fetchEventsForCalendarWithID(calendarID: String,
                                      onFetched: OnFetchedHandler,
                                      onFailur: onFailHandler){
        let query = CalendarQueryFactory.listEventsQueryForCalendarWithID(calendarID)
        
        let _ = service.executeQuery(query) { (ticket, result, error) in
            if let anError = error {
                onFailur(anError)
                self.errorHandler.handleError(anError)
            } else {
                onFetched((result as? GTLRCalendar_Events) ?? GTLRCalendar_Events())
            }
        }
    }
    
    func insertEventAsync(event: GTLRCalendar_Event, onCompeletion:(Bool)->Void) {
        let query = CalendarQueryFactory.insertEventRequestForEvent(event)
        service.executeQuery(query) { (ticket, result, error) in
            if let e = error {
                onCompeletion(false)
                self.errorHandler.handleError(e)
            } else {
                onCompeletion(true)
            }
        }
    }
}
