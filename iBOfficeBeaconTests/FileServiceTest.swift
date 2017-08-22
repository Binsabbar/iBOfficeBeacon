//
//  UTF8DataReaderServiceTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class FileServiceTest: XCTestCase {

    let dummyString = "A dummy string"
    let fileName = "File Service Test.txt"
    let threeDaysAgoDate = Date(timeIntervalSinceNow: oneDay * 3 * -1)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testReturnsLastModifiedDateForAFile() {
        let fileHelper = FileUtilHelper(searchDirectory: FileUtilHelper.documentDirectory)
        fileHelper.writeString(dummyString, toFile: fileName)
        fileHelper.changeFile(fileName, modifiedDateToDate: threeDaysAgoDate)
        
        let service = FileService()
        
        let modifiedDate = service.lastModifiedDateForFileName(fileName)
        
        XCTAssertTrue(modifiedDate.compareDateToSecondPrecision(threeDaysAgoDate) == .orderedSame)
    }
    
    func testReturnsFullFilePathInDocumentDirectory() {
        let expectedFilePath = (FileUtilHelper.documentDirectory as NSString).appendingPathComponent(fileName)
        
        let service = FileService()
        
        let fullPathFile = service.fullPathForFileName(fileName)
        
        XCTAssertTrue(isString(firstString: fullPathFile, equalsToOtherString: expectedFilePath))
    }
    
    func testReturnsTrueIfItWritesDataToAGivenFileInDocumentDirectory() {
        let fileHelper = FileUtilHelper(searchDirectory: FileUtilHelper.documentDirectory)
        fileHelper.deleteFile(fileName)
        let data = dummyString.data(using: String.Encoding.utf8)!
        let service = FileService()
        
        let result = service.writeData(data, toFileName: fileName)
        
        XCTAssertTrue(fileHelper.hasContent(dummyString, beenWrittenToFile: fileName))
        XCTAssertTrue(result)
    }
    
    func testReturnsFalseIfDataCannotBeWritten() {
        let fileHelper = FileUtilHelper(searchDirectory: FileUtilHelper.documentDirectory)
        fileHelper.deleteFile(fileName)
        let data = dummyString.data(using: String.Encoding.utf16)!
        let service = FileService()
        
        let result = service.writeData(data, toFileName: fileName)
        
        XCTAssertFalse(fileHelper.hasContent(dummyString, beenWrittenToFile: fileName))
        XCTAssertFalse(result)
    }
    
    
    func testItDeletesAFileAtDocumentDirectory() {
        let fileToDelete = "testFileDelete.txt"
        let fileHelper = FileUtilHelper(searchDirectory: FileUtilHelper.documentDirectory)
        fileHelper.writeString("some test string", toFile: fileToDelete)
        
        let service = FileService()
        
        service.deleteFile(fileToDelete)
        
        fileHelper.assertFileIsDeleted(fileToDelete)
    }
    
}
