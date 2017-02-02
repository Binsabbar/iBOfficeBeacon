//
//  ErrorHandlerSpy.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 02/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class ErrorHandlerSpy:ErrorHandlingProtocol {
    
    var handleErrorIsCalled = false
    var calledError: NSError!
    
    func handleError(error: NSError) {
        calledError = error
        handleErrorIsCalled = true
    }
}
