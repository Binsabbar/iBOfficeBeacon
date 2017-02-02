//
//  UTF8DataWriterService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class UTF8DataWriterService : NSObject {
    
    private let directory: String
    private let stringEncoding = NSUTF8StringEncoding
    
    init(directoryToWriteIn: String) {
        directory = directoryToWriteIn
    }
    
    func writeDataAsString(dataToWrite: NSData, inFileName fileName: String) -> Bool {
        if let dataAsString = String(data: dataToWrite, encoding: stringEncoding) {
            let filePath = (directory as NSString).stringByAppendingPathComponent(fileName)
            do {
                try dataAsString.writeToFile(filePath, atomically: false, encoding: stringEncoding)
                return true
            }
            catch { }
        }
        return false
    }
}
