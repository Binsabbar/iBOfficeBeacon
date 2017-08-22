class FakeGTLServiceDrive: GTLRDriveService {
    
    override var fetcherService: GTMSessionFetcherService {
        get { return super.fetcherService }
        set { super.fetcherService = newValue}
    }
    
    var fileID: String!
    var lastModifiedDate: Date!
    var error: NSError?
    
    var fakeFetcher: FakeFetcherService!
    
    func stubError(_ error: NSError) {
        self.error = error
    }
    
    func stubFetcherService(_ service: FakeFetcherService) {
        self.fakeFetcher = service
        fetcherService = self.fakeFetcher
    }
    
    func stubGTLDriveFileWithID(_ ID: String) {
        fileID = ID
    }
    
    func stubGTLDriveFileLastModifiedDate(_ date: Date) {
        lastModifiedDate = date
    }
    
    
    override func executeQuery(_ query: GTLRQueryProtocol, completionHandler handler: GTLRServiceCompletionHandler?) -> GTLRServiceTicket {
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
    
    func stubFetcher(_ fetcher: FakeFetcher) {
        self.fetcher = fetcher
    }
    
    override func fetcher(withURLString url: String) -> GTMSessionFetcher {
        return fetcher ?? FakeFetcher()
    }
}

class FakeFetcher:GTMSessionFetcher {
    
    var data: Data!
    var error: NSError!
    
    func stubError(_ error: NSError) {
        self.error = error
    }
    
    func stubFetchedData(_ data: Data) {
        self.data = data
    }
    
    override func beginFetch(completionHandler handler: GTMSessionFetcherCompletionHandler?) {
        handler?(self.data, self.error)
    }
}
