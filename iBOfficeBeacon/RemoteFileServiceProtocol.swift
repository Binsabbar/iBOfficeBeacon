//
//  RemoteFileServiceProtocol.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation


protocol RemoteFileServiceProtocol {
    
    func requestFileMetadataForFileId(_ fileID: String, completionHandler: @escaping (FileMetadata, NSError?) -> ())
    
    func fetchFile(_ file: FileMetadata, fetchCompletionHandler: @escaping (Data?, NSError?)->())
}
