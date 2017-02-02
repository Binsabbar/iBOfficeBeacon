//
//  NSErrorBuilder.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 24/10/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

class NSErrorBuilder {
    
    static func createNSErrorWithCode(errorCode: Int) -> NSError {
        return NSError(domain: "com.google.GTLJSONRPCErrorDomain", code: errorCode, userInfo: nil)
    }
    
    static func createUnauthenticatedUseExceededError() -> NSError {
        let userInfo = ["error": "Daily Limit for Unauthenticated Use Exceeded. Continued use requires signup.",
                        "NSLocalizedFailureReason": "(Daily Limit for Unauthenticated Use Exceeded. Continued use requires signup.)",
                        "GTLStructuredError": "GTLErrorObject 0x13febe650: {message:\"Daily Limit for Unauthenticated Use Exceeded. Continued use requires signup.\" data:[1] code:403}"]
        
        return NSError(domain: "com.google.GTLJSONRPCErrorDomain", code: 403, userInfo: userInfo)
    }
    
}
