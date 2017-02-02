//
//  FakeFileService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FakeFileService : FileService {
    
    var hasWriteDataToFileNameBeenCalled = false
    var fileName: String?
    var writtenData: NSData?
    
    var lastModified: NSDate?
    var writeDataResult = false
    
    var mockWrongFullPathForFileName = false
    
    override func writeData(data: NSData, toFileName name: String) -> Bool {
        hasWriteDataToFileNameBeenCalled = true
        fileName = name
        writtenData = data
        return writeDataResult
    }
    
    override func lastModifiedDateForFileName(name: String) -> NSDate {
        return NSDate()
    }
    
    override func fullPathForFileName(name: String) -> String {
        if mockWrongFullPathForFileName {
            return ""
        }
        return super.fullPathForFileName(name)
    }
    
}
