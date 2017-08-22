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
    
    func requestedFile(_ remoteName: String, hasBeenSavedLocallyToFile localName: String) {
        isRequestedFileCalled = true
    }
    
    func requestingRemoteFileFailedWithError(_ error: NSError) {
        isRequestingRemoteFileFailedWithErrorCalled = true
    }
    
    func fetchingRemoteFileFailedWithError(_ error: NSError) {
        isFetchingRemoteFileFailedWithErrorCalled = true
    }
    
    func fileCouldNotBeSavedTo(_ fileName: String)  {
        isFileCouldNotBeSavedCalled = true
    }
    
    func localFile(_ localName: String, isUpToDateWithRequestedFile remoteName: String) {
        isLocalFileIsUpToDateWithRequestedFileCalled = true
    }
}
