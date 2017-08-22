//
//  FileService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FileService : NSString {
    
    fileprivate let documentDirectory:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                         .userDomainMask,
                                                                         true).first! as NSString
    
    func fullPathForFileName(_ name: String) -> String {
        return documentDirectory.appendingPathComponent(name)
    }
    
    func writeData(_ data: Data, toFileName name: String) -> Bool {
        let writter = UTF8DataWriterService(directoryToWriteIn: documentDirectory as String)
        return writter.writeDataAsString(data, inFileName: name)
    }
    
    func lastModifiedDateForFileName(_ name: String) -> Date {
        let manager = FileManager.default
        do {
            let filePath = documentDirectory.appendingPathComponent(name)
            let attrs = try manager.attributesOfItem(atPath: filePath)
            return attrs[FileAttributeKey.modificationDate] as! Date
        } catch {}
        return Date()
    }
    
    func deleteFile(_ fileName: String) {
        let manager = FileManager.default
        do {
            let filePath = documentDirectory.appendingPathComponent(fileName)
            try manager.removeItem(at: URL(fileURLWithPath: filePath))
        } catch{}
    }
}
