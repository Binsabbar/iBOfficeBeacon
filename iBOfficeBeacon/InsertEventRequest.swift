class InsertEventRequest {
    
    let event: GTLRCalendar_Event
    let requestURL: URL
    
    init(event: GTLRCalendar_Event, url: URL) {
        self.event = event
        self.requestURL = url
    }
}
