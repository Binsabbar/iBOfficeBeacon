//
//  LogoutController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class LogoutController {
    
    let googleAuthController: GoogleAuthController
    let fileService: FileService
    
    init(googleAuthController: GoogleAuthController, fileService: FileService) {
        self.googleAuthController = googleAuthController
        self.fileService = fileService
    }
    
    func logout() {
        fileService.deleteFile(AppSettings.LOCAL_BEACON_ADDRESS_FILE_NAME)
        googleAuthController.logout()
    }
}
