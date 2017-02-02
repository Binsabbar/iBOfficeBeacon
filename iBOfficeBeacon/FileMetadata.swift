//
//  FileMetadata.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FileMetadata:NSObject {
    
    let fileName: String
    let fileId: String
    let modifiedAt: NSDate
    
    init(name: String, id: String, modifiedAt: NSDate) {
        fileName = name
        fileId = id
        self.modifiedAt = modifiedAt
    }
}


class NullFileMetadata : FileMetadata {
    
    init() {
        super.init(name: "", id: "", modifiedAt: NSDate())
    }
    
}
