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
    
    func fetchEventsForCalendarWithID(_ calendarID: String,
                                      onFetched: @escaping OnFetchedHandler,
                                      onFailur: @escaping onFailHandler){
        let query = CalendarQueryFactory.listEventsQueryForCalendarWithID(calendarID)
        
        let _ = service.executeQuery(query) { (ticket, result, error) in
            if let anError = error {
                onFailur(anError as NSError)
                self.errorHandler.handleError(anError as NSError)
            } else {
                onFetched((result as? GTLRCalendar_Events) ?? GTLRCalendar_Events())
            }
        }
    }
    
    func insertEventAsync(_ event: GTLRCalendar_Event, onCompeletion:@escaping (Bool)->Void) {
        let query = CalendarQueryFactory.insertEventRequestForEvent(event)
        service.executeQuery(query) { (ticket, result, error) in
            if let e = error {
                onCompeletion(false)
                self.errorHandler.handleError(e as NSError)
            } else {
                onCompeletion(true)
            }
        }
    }
}
