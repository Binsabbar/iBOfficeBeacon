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
    var writtenData: Data?
    
    var lastModified: Date?
    var writeDataResult = false
    
    var mockWrongFullPathForFileName = false
    
    override func writeData(_ data: Data, toFileName name: String) -> Bool {
        hasWriteDataToFileNameBeenCalled = true
        fileName = name
        writtenData = data
        return writeDataResult
    }
    
    override func lastModifiedDateForFileName(_ name: String) -> Date {
        return Date()
    }
    
    override func fullPathForFileName(_ name: String) -> String {
        if mockWrongFullPathForFileName {
            return ""
        }
        return super.fullPathForFileName(name)
    }
    
}
