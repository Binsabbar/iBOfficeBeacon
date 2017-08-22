//
//  UTF8DataWriterService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class UTF8DataWriterService : NSObject {
    
    fileprivate let directory: String
    fileprivate let stringEncoding = String.Encoding.utf8
    
    init(directoryToWriteIn: String) {
        directory = directoryToWriteIn
    }
    
    func writeDataAsString(_ dataToWrite: Data, inFileName fileName: String) -> Bool {
        if let dataAsString = String(data: dataToWrite, encoding: stringEncoding) {
            let filePath = (directory as NSString).appendingPathComponent(fileName)
            do {
                try dataAsString.write(toFile: filePath, atomically: false, encoding: stringEncoding)
                return true
            }
            catch { }
        }
        return false
    }
}
