//
//  RemoteFileServiceProtocol.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation


protocol RemoteFileServiceProtocol {
    
    func requestFileMetadataForFileId(fileID: String, completionHandler: (FileMetadata, NSError?) -> ())
    
    func fetchFile(file: FileMetadata, fetchCompletionHandler: (NSData?, NSError?)->())
}
