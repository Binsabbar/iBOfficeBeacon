//
//  FileServiceSpy.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FileServiceSpy: FileService {
    
    var isWriteDataCalled = false
    var isDeleteFileCalled = false
    var isLastModifiedCalled = false
    var isFullPathForFileNameCalled = false
    
    var deleteFileParam: String?

    override func writeData(data: NSData, toFileName name: String) -> Bool {
        isWriteDataCalled = true
        return true
    }
    
    override func deleteFile(fileName: String) {
        isDeleteFileCalled = true
        deleteFileParam = fileName
    }
    
    override func lastModifiedDateForFileName(name: String) -> NSDate {
        isLastModifiedCalled = true
        return NSDate()
    }
    
    override func fullPathForFileName(name: String) -> String {
        isFullPathForFileNameCalled = true
        return name
    }
    
}
