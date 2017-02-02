//
//  SheetDriveService.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

protocol SpreadsheetAPIDelegate {
    func localFile(localName: String, isUpToDateWithRequestedFile remoteName: String)
    func requestedFile(remoteName: String, hasBeenSavedLocallyToFile localName: String)
    func requestingRemoteFileFailedWithError(error: NSError)
    func fetchingRemoteFileFailedWithError(error: NSError)
    func fileCouldNotBeSavedTo(fileName: String)
}

class SpreadsheetAPI : NSObject {
    
    private let remoteFileClient: RemoteFileServiceProtocol
    private let fileService: FileService
    private let delegate: SpreadsheetAPIDelegate
    
    init(remoteFileClient: RemoteFileServiceProtocol, fileService: FileService, delegate: SpreadsheetAPIDelegate) {
        self.remoteFileClient = remoteFileClient
        self.fileService = fileService
        self.delegate = delegate
    }
    
    //MARK: TODO - Rename the method
    func saveRemoteSheetFileWithId(id: String, locallyToFile name: String) {
        remoteFileClient.requestFileMetadataForFileId(id) { (fileMeta, error) in
            if let anError = error where fileMeta is NullFileMetadata {
                self.delegate.requestingRemoteFileFailedWithError(anError)
                return
            }
            
            let lastModified = self.fileService.lastModifiedDateForFileName(name)
            if lastModified.compareDateToSecondPrecision(fileMeta.modifiedAt) == .OrderedDescending {
                self.delegate.localFile(name, isUpToDateWithRequestedFile: fileMeta.fileName)
                return
            }
            
            self.fetchFile(fileMeta, andStoreItsContentTo: name)
        }
    }
    
    private func fetchFile(fileMeta: FileMetadata, andStoreItsContentTo localFileName: String) {
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
