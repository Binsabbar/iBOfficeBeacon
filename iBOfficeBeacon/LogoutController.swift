//
//  LogoutController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 26/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class LogoutController {
    
    let authController: AuthController
    let fileService: FileService
    
    init(authController: AuthController, fileService: FileService) {
        self.authController = authController
        self.fileService = fileService
    }
    
    func logout() {
        authController.logout()
        fileService.deleteFile(AppSettings.LOCAL_BEACON_ADDRESS_FILE_NAME)
    }
}
