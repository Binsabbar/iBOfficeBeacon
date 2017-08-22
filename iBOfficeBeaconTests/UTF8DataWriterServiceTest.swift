//
//  FileWriterTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class UTF8DataWriterServiceTest: XCTestCase {

    var service: UTF8DataWriterService!
    
    let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask,
                                                        true).first
    let fileName = "FileWriteServiceTest.txt"
    let dummyString = "Random string to write to a file"
    
    var fileTestHelper: FileUtilHelper!
    
    override func setUp() {
        super.setUp()
        fileTestHelper = FileUtilHelper(searchDirectory: directory!)
        fileTestHelper.deleteFile(fileName)
        service = UTF8DataWriterService(directoryToWriteIn: directory!)
    }
    
    override func tearDown() {
        super.tearDown()
        fileTestHelper.deleteFile(fileName)
    }

    func testItReturnsTrueIfDataIsWrittenToAFile() {
        let dataToWrite = dummyString.data(using: String.Encoding.utf8)
        
        let result = service.writeDataAsString(dataToWrite!, inFileName: fileName)
        
        XCTAssertTrue(fileTestHelper.hasContent(dummyString, beenWrittenToFile: fileName))
        XCTAssertTrue(result)
    }
    
    func testItOverwritesDataIfFileExists() {
        let oldContent = "file old content"
        fileTestHelper.writeString(oldContent, toFile: fileName)
        
        let newContent = "New content in the file"
        let dataToWrite = newContent.data(using: String.Encoding.utf8)
        
        let result = service.writeDataAsString(dataToWrite!, inFileName: fileName)
        
        XCTAssertFalse(fileTestHelper.hasContent(oldContent, beenWrittenToFile: fileName))
        XCTAssertTrue(fileTestHelper.hasContent(newContent, beenWrittenToFile: fileName))
        XCTAssertTrue(result)
    }
    
    
    func testItReturnsFalseIfDataIsWritenToAFile() {
        let invalidFileName = "</ -_- />,filename"
        let dataToWrite = dummyString.data(using: String.Encoding.utf8)
        
        let result = service.writeDataAsString(dataToWrite!, inFileName: invalidFileName)
        
        XCTAssertFalse(fileTestHelper.hasContent(dummyString, beenWrittenToFile: invalidFileName))
        XCTAssertFalse(result)
    }
    
    func testItReturnsFalseIfDataIsNotEncodedAsUTF8() {
        let dataToWrite = dummyString.data(using: String.Encoding.utf32)
        
        let result = service.writeDataAsString(dataToWrite!, inFileName: fileName)
        
        XCTAssertFalse(fileTestHelper.hasContent(dummyString, beenWrittenToFile: fileName))
        XCTAssertFalse(result)
    }
    
}
