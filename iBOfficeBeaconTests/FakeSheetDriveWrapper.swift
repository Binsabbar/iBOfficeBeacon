//
//  FakeSheetDriveWrapper.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class FakeSheetDriveWrapper: RemoteFileServiceProtocol {
    
    let queue = DispatchQueue(label: "FakeSheetDriveWrapper", attributes: [])
    
    var requestedFileId: String?
    var fileMetadata: FileMetadata?
    var requestFileError: NSError?
    
    var fetchedData: Data?
    var fetchingFileError: NSError?
    
    var hasFetchedFileCalled = false
    var hasRequestFileMetadataForIdCalled = false
    
    func fetchFile(_ file: FileMetadata, fetchCompletionHandler: @escaping (Data?, NSError?) -> ()) {
        queue.async {
            self.hasFetchedFileCalled = true
            if let data = self.fetchedData {
                fetchCompletionHandler(data, nil)
            } else {
                fetchCompletionHandler(nil, self.fetchingFileError)
            }
        }
    }
    
    func requestFileMetadataForFileId(_ fileId: String, completionHandler: @escaping (FileMetadata, NSError?) -> ()) {
        
        queue.async {
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
