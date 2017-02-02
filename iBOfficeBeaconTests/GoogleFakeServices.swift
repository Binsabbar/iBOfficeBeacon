class FakeGTLServiceDrive: GTLRDriveService {
    
    override var fetcherService: GTMSessionFetcherService {
        get { return super.fetcherService }
        set { super.fetcherService = newValue}
    }
    
    var fileID: String!
    var lastModifiedDate: NSDate!
    var error: NSError?
    
    var fakeFetcher: FakeFetcherService!
    
    func stubError(error: NSError) {
        self.error = error
    }
    
    func stubFetcherService(service: FakeFetcherService) {
        self.fakeFetcher = service
        fetcherService = self.fakeFetcher
    }
    
    func stubGTLDriveFileWithID(ID: String) {
        fileID = ID
    }
    
    func stubGTLDriveFileLastModifiedDate(date: NSDate) {
        lastModifiedDate = date
    }
    
    
    override func executeQuery(query: GTLRQueryProtocol, completionHandler handler: GTLRServiceCompletionHandler?) -> GTLRServiceTicket {
        let file = GTLRDrive_File()
        file.identifier = self.fileID
        if lastModifiedDate != nil {
           file.modifiedTime = GTLRDateTime(date: lastModifiedDate)
        }
        
        super.testBlock = { (ticket, testRsponse) in
            testRsponse(file, self.error)
        }
        return super.executeQuery(query, completionHandler: handler)
    }
    
}

class FakeFetcherService: GTMSessionFetcherService {
    
    var fetcher: FakeFetcher!
    
    func stubFetcher(fetcher: FakeFetcher) {
        self.fetcher = fetcher
    }
    
    override func fetcherWithURLString(url: String) -> GTMSessionFetcher {
        return fetcher ?? FakeFetcher()
    }
}

class FakeFetcher:GTMSessionFetcher {
    
    var data: NSData!
    var error: NSError!
    
    func stubError(error: NSError) {
        self.error = error
    }
    
    func stubFetchedData(data: NSData) {
        self.data = data
    }
    
    override func beginFetchWithCompletionHandler(handler: GTMSessionFetcherCompletionHandler?) {
        handler?(self.data, self.error)
    }
}
