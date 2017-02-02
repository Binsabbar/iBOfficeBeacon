class InsertEventRequest {
    
    let event: GTLRCalendar_Event
    let requestURL: NSURL
    
    init(event: GTLRCalendar_Event, url: NSURL) {
        self.event = event
        self.requestURL = url
    }
}
