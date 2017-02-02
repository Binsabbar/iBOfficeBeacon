//
//  DriveWrapper.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class SheetDriveWrapper: NSObject, RemoteFileServiceProtocol {
    
    private let serviceDrive: GTLRDriveService
    
    typealias requestHandler = (FileMetadata, NSError?) -> ()
    typealias fetcherHandler = (NSData?, NSError?)->()
    
    init(withService aService:GTLRDriveService){
        serviceDrive = aService
    }
    
    func requestFileMetadataForFileId(fileId: String, completionHandler: requestHandler) {
        let query = GTLRDriveQuery_FilesGet.queryWithFileId(fileId)
        serviceDrive.executeQuery(query) { (ticket, result, error) in
            if error != nil {
                completionHandler(NullFileMetadata(), error)
            }
            
            if let file = result as? GTLRDrive_File {
                let modifiedAt = file.modifiedTime?.date ?? NSDate()
                let fileMeta = FileMetadata(name: file.name!, id: file.identifier!, modifiedAt: modifiedAt)
                completionHandler(fileMeta, nil)
            }
        }
    }
    
    func fetchFile(file: FileMetadata, fetchCompletionHandler: fetcherHandler) {
        let query = GTLRDriveQuery_FilesExport.queryForMediaWithFileId(file.fileId, mimeType: "text/csv")
        serviceDrive.executeQuery(query) { (ticket, data, error) in
            fetchCompletionHandler((data as? GTLRDataObject)?.data, error)
        }
    }
}
