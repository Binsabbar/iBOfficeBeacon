//
//  SheetDriveServiceDelegateSpy.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 20/07/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class SpreadsheetAPIDelegateSpy : SpreadsheetAPIDelegate {
    
    var isRequestedFileCalled = false
    var isRequestingRemoteFileFailedWithErrorCalled = false
    var isFetchingRemoteFileFailedWithErrorCalled = false
    var isFileCouldNotBeSavedCalled = false
    var isLocalFileIsUpToDateWithRequestedFileCalled = false
    
    func requestedFile(remoteName: String, hasBeenSavedLocallyToFile localName: String) {
        isRequestedFileCalled = true
    }
    
    func requestingRemoteFileFailedWithError(error: NSError) {
        isRequestingRemoteFileFailedWithErrorCalled = true
    }
    
    func fetchingRemoteFileFailedWithError(error: NSError) {
        isFetchingRemoteFileFailedWithErrorCalled = true
    }
    
    func fileCouldNotBeSavedTo(fileName: String)  {
        isFileCouldNotBeSavedCalled = true
    }
    
    func localFile(localName: String, isUpToDateWithRequestedFile remoteName: String) {
        isLocalFileIsUpToDateWithRequestedFileCalled = true
    }
}
