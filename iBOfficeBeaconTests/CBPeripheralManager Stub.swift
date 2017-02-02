//
//  CBPeripheralManager Stub.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 08/06/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation

@available(iOS 10.0, *)
class CBPeripheralManagerStub: CBPeripheralManager {
    
    private var curentState: CBManagerState?
    
    func setCBPeripheralState(state: CBManagerState) {
        curentState = state
    }
    
    override var state: CBManagerState {
        get {
            return curentState ?? .Unknown
        }
    }
}
