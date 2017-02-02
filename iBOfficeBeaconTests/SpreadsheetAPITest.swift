
//
//  SheetDriveServiceTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class SpreadsheetAPITest: XCTestCase {
    
    var spreadsheetAPI: SpreadsheetAPI!
    
    var fakeSheetDriveWrapper: FakeSheetDriveWrapper!
    var fakeFileService: FakeFileService!
    var delegateSpy: SpreadsheetAPIDelegateSpy!
    
    var fileHelper = FileUtilHelper(searchDirectory: FileUtilHelper.documentDirectory)
    
    var testExpectation: XCTestExpectation!
    
    let remoteFile = "remote file id"
    let localFile = "local file.txt"
    let dummyFetchedData = "dummy string".dataUsingEncoding(NSUTF8StringEncoding)
    let dummyError = NSError(domain: "someError", code: 1, userInfo: nil)
    
    var remoteFileMeta: FileMetadata {
        get {
            return FileMetadata(name: "file name", id: remoteFile, modifiedAt: NSDate())
        }
    }
    
    override func setUp() {
        super.setUp()
        
        fakeSheetDriveWrapper = FakeSheetDriveWrapper()
        fakeFileService = FakeFileService()
        delegateSpy = SpreadsheetAPIDelegateSpy()
        
        spreadsheetAPI = SpreadsheetAPI(remoteFileClient: fakeSheetDriveWrapper,
                                    fileService: fakeFileService,
                                    delegate: delegateSpy)
        
        testExpectation =  expectationWithDescription("SheetDriveServiceTest")
    }
    
    override func tearDown() {
        super.tearDown()
        fileHelper.deleteFile(localFile)
    }
    
    func testItRequestsRemoteFileMetadataForTheGivenFileId() {
        fakeSheetDriveWrapper.fileMetadata = remoteFileMeta
        fakeSheetDriveWrapper.fetchedData = dummyFetchedData
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(self.fakeSheetDriveWrapper.hasRequestFileMetadataForIdCalled)
            XCTAssertTrue(self.fakeSheetDriveWrapper.requestedFileId == self.remoteFile)
        }
    }
    
    // MARK: Fetching File content
    // MARK: When Local file does not exists
    func testItFetchesTheContentOfTheRemoteFileIfLocalFileIsFound() {
        fileHelper.assertFileIsDeleted(localFile)
        
        fakeSheetDriveWrapper.fileMetadata = remoteFileMeta
        fakeSheetDriveWrapper.fetchedData = dummyFetchedData
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(self.fakeSheetDriveWrapper.hasFetchedFileCalled)
            XCTAssertTrue(self.fakeSheetDriveWrapper.fetchedData == self.dummyFetchedData)
            XCTAssertTrue(self.fakeFileService.fileName == self.localFile)
        }
    }
    
    // MARK: When local file exists, but it is not up to date with remote
    func testItFetchesTheContentOfTheRemoteFileWhenLocalFileModifiedDateIsEarlierThanRemoteFile() {
        let twoDaysAgo = NSDate(timeIntervalSinceNow: past2Hours)
        fileHelper.writeString("Some Random data", toFile: localFile)
        fileHelper.changeFile(localFile, modifiedDateToDate: twoDaysAgo)
        
        fakeSheetDriveWrapper.fileMetadata = remoteFileMeta
        fakeSheetDriveWrapper.fetchedData = dummyFetchedData
        fakeFileService.writeDataResult = true
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(self.fakeFileService.hasWriteDataToFileNameBeenCalled)
            XCTAssertTrue(self.fakeFileService.writtenData == self.dummyFetchedData)
            XCTAssertTrue(self.fakeFileService.fileName == self.localFile)
        }
    }
    
    // MARK: When local file exists, but it is up to date with remote
    func testItDoesNotFetcheTheContentOfTheRemoteFileWhenLocalFileModifiedDateIsLaterThanRemoteFile() {
        let twoDaysAgo = NSDate(timeIntervalSinceNow: past2Hours)
        fileHelper.writeString("Some Random data", toFile: localFile)
        fileHelper.changeFile(localFile, modifiedDateToDate: NSDate())
        
        fakeSheetDriveWrapper.fileMetadata = FileMetadata(name: remoteFile, id: remoteFile, modifiedAt: twoDaysAgo)
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertFalse(self.fakeSheetDriveWrapper.hasFetchedFileCalled)
            XCTAssertFalse(self.fakeFileService.hasWriteDataToFileNameBeenCalled)
        }
    }
    
    //MARK: Saving file content
    func testItSavesTheContentOfTheFetchedFileLocallyToTheGivnFileName() {
        fakeSheetDriveWrapper.fileMetadata = remoteFileMeta
        fakeSheetDriveWrapper.fetchedData = dummyFetchedData
        fakeFileService.writeDataResult = true
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(self.fakeFileService.hasWriteDataToFileNameBeenCalled)
            XCTAssertTrue(self.fakeFileService.writtenData == self.dummyFetchedData)
            XCTAssertTrue(self.fakeFileService.fileName == self.localFile)
        }
    }
    
    // MARK: Delegate methods invocations
    func testItInvokesItsDelegateWhenRemoteFileContentHasNotModifiedCompareToLocalOne() {
        let twoDaysAgo = NSDate(timeIntervalSinceNow: oneDay * 2 * -1)
        fileHelper.writeString("Some Random data", toFile: localFile)
        fileHelper.changeFile(localFile, modifiedDateToDate: NSDate())
        
        fakeSheetDriveWrapper.fileMetadata = FileMetadata(name: remoteFile, id: remoteFile, modifiedAt: twoDaysAgo)
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(self.delegateSpy.isLocalFileIsUpToDateWithRequestedFileCalled)
            XCTAssertFalse(self.fakeSheetDriveWrapper.hasFetchedFileCalled)
        }
    }
    
    func testItInvokesItsDelegateWhenTheFileIsSavedLocally() {
        fakeSheetDriveWrapper.fileMetadata = remoteFileMeta
        fakeSheetDriveWrapper.fetchedData = dummyFetchedData
        fakeFileService.writeDataResult = true
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertTrue(self.delegateSpy.isRequestedFileCalled)
        }
    }
    
    func testItInvokesRequestFileFailedWithErrorWhenFileMetadataIsNull() {
        fakeSheetDriveWrapper.requestFileError = dummyError
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertFalse(self.delegateSpy.isRequestedFileCalled)
            XCTAssertTrue(self.delegateSpy.isRequestingRemoteFileFailedWithErrorCalled)
        }
    }
    
    func testItInvokesFetchingFileFailedWithErrorWhenRemoteFileCannotBeFetched() {
        fakeSheetDriveWrapper.fileMetadata = remoteFileMeta
        fakeSheetDriveWrapper.fetchingFileError = dummyError
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertFalse(self.delegateSpy.isRequestedFileCalled)
            XCTAssertTrue(self.delegateSpy.isFetchingRemoteFileFailedWithErrorCalled)
        }
    }
    
    func testItInvokesFileCouldNotBeSavedWhenFileCouldNotBeSaved() {
        fakeSheetDriveWrapper.fileMetadata = remoteFileMeta
        fakeSheetDriveWrapper.fetchedData = dummyFetchedData
        fakeFileService.writeDataResult = false
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFile, locallyToFile: localFile)
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectationsWithTimeout(halfSecond) { _ in
            XCTAssertFalse(self.delegateSpy.isRequestedFileCalled)
            XCTAssertTrue(self.delegateSpy.isFileCouldNotBeSavedCalled)
        }
    }
}
