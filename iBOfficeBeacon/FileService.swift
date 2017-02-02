//
//  FileService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FileService : NSString {
    
    private let documentDirectory:NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                                         .UserDomainMask,
                                                                         true).first!
    
    func fullPathForFileName(name: String) -> String {
        return documentDirectory.stringByAppendingPathComponent(name)
    }
    
    func writeData(data: NSData, toFileName name: String) -> Bool {
        let writter = UTF8DataWriterService(directoryToWriteIn: documentDirectory as String)
        return writter.writeDataAsString(data, inFileName: name)
    }
    
    func lastModifiedDateForFileName(name: String) -> NSDate {
        let manager = NSFileManager.defaultManager()
        do {
            let filePath = documentDirectory.stringByAppendingPathComponent(name)
            let attrs = try manager.attributesOfItemAtPath(filePath)
            return attrs[NSFileModificationDate] as! NSDate
        } catch {}
        return NSDate()
    }
    
    func deleteFile(fileName: String) {
        let manager = NSFileManager.defaultManager()
        do {
            let filePath = documentDirectory.stringByAppendingPathComponent(fileName)
            try manager.removeItemAtURL(NSURL(fileURLWithPath: filePath))
        } catch{}
    }
}
