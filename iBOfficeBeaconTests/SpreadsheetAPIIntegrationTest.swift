//
//  SheetDriveWrapperIntegrationTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 23/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class SpreadsheetAPIIntegrationTest: XCTestCase {

    
    var spreadsheetAPI: SpreadsheetAPI!
    
    var sheetDriveWrapper: SheetDriveWrapper!
    var fakeServiceDrive: GTLRDriveService!
    
    var fileService: FileService!
    var delegateSpy: SpreadsheetAPIDelegateSpy!
    
    var localFileName = "integration-test.csv"
    
    var remoteFileName = "remoteFileName"
    var remoteFileContent = "Some content for the remote file".data(using: String.Encoding.utf8)
    
    var fileHelper = FileUtilHelper(searchDirectory: FileUtilHelper.documentDirectory)
    
    override func setUp() {
        super.setUp()
        fileHelper.deleteFile(localFileName)
        
        fakeServiceDrive = GTLRDriveService()
        sheetDriveWrapper = SheetDriveWrapper(withService: fakeServiceDrive)
        
        fileService = FileService()
        delegateSpy = SpreadsheetAPIDelegateSpy()
        
        spreadsheetAPI = SpreadsheetAPI(remoteFileClient: sheetDriveWrapper,
                                        fileService: fileService,
                                        delegate: delegateSpy)
    }
    
    override func tearDown() {
        super.tearDown()
        fileHelper.deleteFile(localFileName)
    }
    
    func testItLoadsRemoteSpreadsheetAndSavesItLocally() {
        let testExpectation = expectation(description: "SpreadSheetAPI Integration Test")
        
        fakeServiceDrive.testBlock = { (ticket, testResponse) in
            if ticket.originalQuery is GTLRDriveQuery_FilesGet {
                testResponse(self.fakeRemoteGTLDriveFile(), nil)
            } else if ticket.originalQuery is GTLRDriveQuery_FilesExport {
                let googleData = GTLRDataObject()
                googleData.data = self.remoteFileContent!
                testResponse(googleData, nil)
            }
        }
        
        spreadsheetAPI.saveRemoteSheetFileWithId(remoteFileName, locallyToFile: localFileName)
        
        let savedFileContent = String(data: remoteFileContent!, encoding: String.Encoding.utf8)!
        
        fullfillExpectation(testExpectation, withinTime: hundredMs)
        
        waitForExpectations(timeout: halfSecond) { _ in
            XCTAssertTrue(self.fileHelper.hasContent(savedFileContent, beenWrittenToFile: self.localFileName))
        }
    }
    
    fileprivate func fakeRemoteGTLDriveFile() -> GTLRDrive_File {
        let fakeFileObject = GTLRDrive_File()
        fakeFileObject.name = remoteFileName
        fakeFileObject.identifier = remoteFileName
        fakeFileObject.modifiedTime = GTLRDateTime(date: Date())
        return fakeFileObject
    }
}
