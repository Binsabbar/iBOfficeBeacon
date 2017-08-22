 //
//  ServiceDriveMockHelpers.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 13/08/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.

import Foundation

class ServiceDriveMockHelper {
    
    static func mockDriveFetchServiceWithRemoteData(_ fetchedString: String, forSheetID sheetID: String) -> GTLRDriveService {
        
        let serviceDrive = GTLRDriveService()
        serviceDrive.testBlock = { (ticket, testResponse) in
            
            if ticket.originalQuery is GTLRDriveQuery_FilesGet {
                if isQueryFileID(ticket.originalQuery!, EqualTosheetID: sheetID) {
                    let driveFile = initDriveFile(sheetID)
                    testResponse(driveFile, nil)
                    return
                }
            } else if ticket.originalQuery is GTLRDriveQuery_FilesExport {
                let googleData = GTLRDataObject()
                googleData.data = fetchedString.data(using: String.Encoding.utf8)!
                testResponse(googleData, nil)
                return
            }
            testResponse(nil, NSError(domain: "MockHelperQueryError", code: 1, userInfo: nil))
            return
        }
        
        return serviceDrive
    }

    static func mockDriveServiceRequestFileWithError(_ error: NSError) -> GTLRDriveService {
        let serviceDrive = GTLRDriveService()
        serviceDrive.testBlock = { (ticket, testResponse) in
            testResponse(nil, error)
        }
        return serviceDrive
    }
    
    static func mockDriveFetchServiceWithError(_ error: NSError, forSheetID sheetID: String) -> GTLRDriveService {
        
        let serviceDrive = GTLRDriveService()
        serviceDrive.testBlock = { (ticket, testResponse) in
            if isQueryFileID(ticket.originalQuery!, EqualTosheetID: sheetID) {
                let driveFile = initDriveFile(sheetID)
                testResponse(driveFile, nil)
                return
            }
            testResponse(nil, error)
        }
        return serviceDrive
    }

    fileprivate static func isQueryFileID(_ query: GTLRQueryProtocol, EqualTosheetID sheetID: String) -> Bool{
        return query is GTLRDriveQuery_FilesGet && (query as! GTLRDriveQuery_FilesGet).fileId == sheetID
    }
    
    fileprivate static func initDriveFile(_ sheetID: String) -> GTLRDrive_File {
        let driveFile = GTLRDrive_File()
        driveFile.name = sheetID
        driveFile.identifier = sheetID
        driveFile.modifiedTime = GTLRDateTime(date: Date())
        return driveFile
    }
}
