//
//  SheetDriveService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

protocol SpreadsheetAPIDelegate {
    func localFile(_ localName: String, isUpToDateWithRequestedFile remoteName: String)
    func requestedFile(_ remoteName: String, hasBeenSavedLocallyToFile localName: String)
    func requestingRemoteFileFailedWithError(_ error: NSError)
    func fetchingRemoteFileFailedWithError(_ error: NSError)
    func fileCouldNotBeSavedTo(_ fileName: String)
}

class SpreadsheetAPI : NSObject {
    
    fileprivate let remoteFileClient: RemoteFileServiceProtocol
    fileprivate let fileService: FileService
    fileprivate let delegate: SpreadsheetAPIDelegate
    
    init(remoteFileClient: RemoteFileServiceProtocol, fileService: FileService, delegate: SpreadsheetAPIDelegate) {
        self.remoteFileClient = remoteFileClient
        self.fileService = fileService
        self.delegate = delegate
    }
    
    //MARK: TODO - Rename the method
    func saveRemoteSheetFileWithId(_ id: String, locallyToFile name: String) {
        remoteFileClient.requestFileMetadataForFileId(id) { (fileMeta, error) in
            if let anError = error, fileMeta is NullFileMetadata {
                self.delegate.requestingRemoteFileFailedWithError(anError)
                return
            }
            
            let lastModified = self.fileService.lastModifiedDateForFileName(name)
            if lastModified.compareDateToSecondPrecision(fileMeta.modifiedAt) == .orderedDescending {
                self.delegate.localFile(name, isUpToDateWithRequestedFile: fileMeta.fileName)
                return
            }
            
            self.fetchFile(fileMeta, andStoreItsContentTo: name)
        }
    }
    
    fileprivate func fetchFile(_ fileMeta: FileMetadata, andStoreItsContentTo localFileName: String) {
        self.remoteFileClient.fetchFile(fileMeta) { (data, error) in
            if let anError = error {
                self.delegate.fetchingRemoteFileFailedWithError(anError)
                return
            }
            
            if !self.fileService.writeData(data!, toFileName: localFileName) {
                self.delegate.fileCouldNotBeSavedTo(localFileName)
                return
            }
            self.delegate.requestedFile(fileMeta.fileName, hasBeenSavedLocallyToFile: localFileName)
        }
    }
}
