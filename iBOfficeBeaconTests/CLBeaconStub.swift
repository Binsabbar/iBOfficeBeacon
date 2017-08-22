//
//  CLBeaconStub.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 31/01/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
class CLBeaconStub: CLBeacon {
    
    fileprivate var stubProximity:CLProximity = .immediate
    fileprivate var stubMajor: NSNumber!
    fileprivate var stubMinor: NSNumber!
    fileprivate var stubProximityUUID: UUID!
    fileprivate var stubAccuracy: CLLocationAccuracy!
    
    override var proximity:CLProximity {
        get {
            return stubProximity
        }
        set {
            stubProximity = newValue
        }
    }
    
    override var proximityUUID: UUID {
        get {
            return stubProximityUUID
        }
        set {
            stubProximityUUID = newValue
        }
    }
    
    override var major: NSNumber {
        get {
            return stubMajor
        }
        set {
            stubMajor = newValue
        }
    }
    
    override var minor: NSNumber {
        get {
            return stubMinor
        }
        set {
            stubMinor = newValue
        }
    }
    
    override var accuracy: CLLocationAccuracy {
        get {
            return stubAccuracy
        }
        set {
            stubAccuracy = newValue
        }
    }
    
    init(proximity: CLProximity){
        super.init()
        self.major = NSNumber(value: 1 as Int32)
        self.minor = NSNumber(value: 1 as Int32)
        self.proximityUUID = UUID()
        self.accuracy = CLLocationAccuracy(0.1)
        stubProximity = proximity
    }
    
    init(withUUID uuid:UUID, andMajor major: Int, andProximity proximity: CLProximity){
        super.init()
        self.minor = NSNumber(value: 1 as Int32)
        self.major = NSNumber(integerLiteral: major)
        self.accuracy = CLLocationAccuracy(0.1)
        self.proximityUUID = uuid
        stubProximity = proximity
    }
    
    init(uuid:UUID, major: Int, minor: Int, proximity: CLProximity, accuracy: Double){
        super.init()
        self.proximityUUID = uuid
        self.minor = NSNumber(integerLiteral: minor)
        self.major = NSNumber(integerLiteral: major)
        self.accuracy = CLLocationAccuracy(accuracy)
        stubProximity = proximity
    }
    
    init(withUUID uuid:UUID, andMajor major: Int, andMinor minor: Int){
        super.init()
        self.major = NSNumber(integerLiteral: major)
        self.minor = NSNumber(integerLiteral: minor)
        self.accuracy = CLLocationAccuracy(0.1)
        self.proximityUUID = uuid
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
