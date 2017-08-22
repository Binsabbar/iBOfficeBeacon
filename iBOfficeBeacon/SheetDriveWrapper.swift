//
//  DriveWrapper.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 17/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class SheetDriveWrapper: NSObject, RemoteFileServiceProtocol {
    
    fileprivate let serviceDrive: GTLRDriveService
    
    typealias requestHandler = (FileMetadata, NSError?) -> ()
    typealias fetcherHandler = (Data?, NSError?)->()
    
    init(withService aService:GTLRDriveService){
        serviceDrive = aService
    }
    
    func requestFileMetadataForFileId(_ fileId: String, completionHandler: @escaping requestHandler) {
        let query = GTLRDriveQuery_FilesGet.query(withFileId: fileId)
        serviceDrive.executeQuery(query) { (ticket, result, error) in
            if error != nil {
                completionHandler(NullFileMetadata(), error! as NSError)
            }
            
            if let file = result as? GTLRDrive_File {
                let modifiedAt = file.modifiedTime?.date ?? Date()
                let fileMeta = FileMetadata(name: file.name!, id: file.identifier!, modifiedAt: modifiedAt)
                completionHandler(fileMeta, nil)
            }
        }
    }
    
    func fetchFile(_ file: FileMetadata, fetchCompletionHandler: @escaping fetcherHandler) {
        let query = GTLRDriveQuery_FilesExport.queryForMedia(withFileId: file.fileId, mimeType: "text/csv")
        
        serviceDrive.executeQuery(query) { (ticket, data, error) in
            let dataObject:Data? = (data as? GTLRDataObject)?.data
            fetchCompletionHandler(dataObject, error as NSError?)
        }
    }
}
