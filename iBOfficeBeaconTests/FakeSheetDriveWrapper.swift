//
//  FakeSheetDriveWrapper.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FakeSheetDriveWrapper: RemoteFileServiceProtocol {
    
    let queue = dispatch_queue_create("FakeSheetDriveWrapper", nil)
    
    var requestedFileId: String?
    var fileMetadata: FileMetadata?
    var requestFileError: NSError?
    
    var fetchedData: NSData?
    var fetchingFileError: NSError?
    
    var hasFetchedFileCalled = false
    var hasRequestFileMetadataForIdCalled = false
    
    func fetchFile(file: FileMetadata, fetchCompletionHandler: (NSData?, NSError?) -> ()) {
        dispatch_async(queue) {
            self.hasFetchedFileCalled = true
            if let data = self.fetchedData {
                fetchCompletionHandler(data, nil)
            } else {
                fetchCompletionHandler(nil, self.fetchingFileError)
            }
        }
    }
    
    func requestFileMetadataForFileId(fileId: String, completionHandler: (FileMetadata, NSError?) -> ()) {
        
        dispatch_async(queue) {
            self.hasRequestFileMetadataForIdCalled = true
            self.requestedFileId = fileId
            if let file = self.fileMetadata {
                completionHandler(file, nil)
            } else {
                completionHandler(NullFileMetadata(), self.requestFileError)
            }
        }
    }
}
