//
//  GTLDriveClientTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 15/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class SheetDriveWrapperTest: XCTestCase {
    
    var client: SheetDriveWrapper!
    
    let fileId = "test file id"
    
    let dummyCompeletionHandler: SheetDriveWrapper.requestHandler = {_ in}
    
    var testExpectation: XCTestExpectation!
    var delegate: NSObject!
    var service: GTLRDriveService!
    
    override func setUp() {
        super.setUp()
        delegate = NSObject()
        service = GTLRDriveService()
        testExpectation = expectationWithDescription("GTLDriveClientTest")
        client = SheetDriveWrapper(withService: service)
    }

    func testItCallsTheServiceWithFileIDInTheQuery() {
        service.testBlock = { (ticket, testResponse) in
            let query = ticket.originalQuery as! GTLRDriveQuery_FilesGet
            XCTAssertTrue(query.fileId == self.fileId)
            self.testExpectation.fulfill()
            testResponse(nil, nil)
        }
        
        client.requestFileMetadataForFileId(fileId, completionHandler: dummyCompeletionHandler)
        
        waitForExpectationsWithTimeout(twoSeconds) { _ in}
    }
    
    func testItCallsCompletionBlockWithFileObjectIfFileIsFound() {
        let fakeFileObject = fakeRemoteDriveFile()
        service.testBlock = { (ticket, testResponse) in
            testResponse(fakeFileObject, nil)
        }
        
        client.requestFileMetadataForFileId(fileId) { (fileMeta, error) in
            XCTAssertTrue(fileMeta.fileId == fakeFileObject.identifier)
            XCTAssertTrue(fileMeta.fileName == fakeFileObject.name)
            XCTAssertTrue(fileMeta.modifiedAt == fakeFileObject.modifiedTime!.date)
            self.testExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(twoSeconds) { _ in}
    }
    
    func testItCallsCompletionBlockWithNSErrorIfFileIsNotFound() {
        service.testBlock = { (ticket, testResponse) in
            let error = NSError(domain: "", code: 1, userInfo: [kGTMOAuth2ErrorUnauthorizedClient: "dummyError"])
            testResponse(nil, error)
        }
        
        client.requestFileMetadataForFileId(fileId) { (fileMeta, error) in
            XCTAssertNotNil(error)
            XCTAssertTrue(fileMeta.isKindOfClass(NullFileMetadata))
            self.testExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(twoSeconds) { _ in}
    }
    
    func testItSetsExportMimeTypeToText_CSV() {
        let anId = "123abc"
    
        service.testBlock = { (ticket, testResponse) in
            let query = ticket.originalQuery as! GTLRDriveQuery_FilesExport
            XCTAssertTrue(query.mimeType == "text/csv")
            self.testExpectation.fulfill()
            testResponse(nil, nil)
        }

        client.fetchFile(dummyFileMetaWithID(anId)){_ in}	
    
        waitForExpectationsWithTimeout(second) {_ in}
    }
    
    func testItSetsFileIdInTheQueryWhenItExportsFile() {
        let anId = "123abc"
        
        service.testBlock = { (ticket, testResponse) in
            let query = ticket.originalQuery as! GTLRDriveQuery_FilesExport
            XCTAssertTrue(query.fileId == anId)
            self.testExpectation.fulfill()
            testResponse(nil, nil)
        }
        
        client.fetchFile(dummyFileMetaWithID(anId)){_ in}
        
        waitForExpectationsWithTimeout(second) {_ in}
    }
    
    func testItCallsCompletionHandlerWithTheFileData() {
        let stringInFile = "hello world"
        let dummyFileData = stringInFile.dataUsingEncoding(NSUTF8StringEncoding)
    
        service.fetcherService = GTMSessionFetcherService.mockFetcherServiceWithFakedData(dummyFileData, fakedError: nil)
        
        client.fetchFile(dummyFileMetaWithID(fileId)) { (data, _) in
            let dataAsString = String(data: data!, encoding: NSUTF8StringEncoding)!
            XCTAssertTrue(isString(firstString: dataAsString, equalsToOtherString: stringInFile))
            self.testExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(second) {_ in}
    }
 
    func testItCallsCompletionHandlerWithNSErrorIfFileCouldNotBeFetched() {
        let error = NSError(domain: "error", code: 1, userInfo: nil)
        service.fetcherService = GTMSessionFetcherService.mockFetcherServiceWithFakedData(nil, fakedError: error)
        
        client.fetchFile(dummyFileMetaWithID(fileId)) { (data, anError) in
            XCTAssertNotNil(anError)
            self.testExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(second) {_ in}
    }
    
    private func dummyFileMetaWithID(id: String) -> FileMetadata {
        return FileMetadata(name: "random", id: id, modifiedAt: NSDate())
    }
    
    private func fakeRemoteDriveFile() -> GTLRDrive_File {
        let fakeFileObject = GTLRDrive_File()
        fakeFileObject.name = "The file name"
        fakeFileObject.identifier = fileId
        fakeFileObject.modifiedTime = GTLRDateTime(date: NSDate())
        return fakeFileObject
    }
}
