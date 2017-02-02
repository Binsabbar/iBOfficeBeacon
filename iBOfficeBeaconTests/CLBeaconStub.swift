//
//  CLBeaconStub.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 31/01/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import Foundation
class CLBeaconStub: CLBeacon {
    
    private var stubProximity:CLProximity = .Immediate
    private var stubMajor: NSNumber!
    private var stubMinor: NSNumber!
    private var stubProximityUUID: NSUUID!
    private var stubAccuracy: CLLocationAccuracy!
    
    override var proximity:CLProximity {
        get {
            return stubProximity
        }
        set {
            stubProximity = newValue
        }
    }
    
    override var proximityUUID: NSUUID {
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
        self.major = NSNumber(int: 1)
        self.minor = NSNumber(int: 1)
        self.proximityUUID = NSUUID()
        self.accuracy = CLLocationAccuracy(0.1)
        stubProximity = proximity
    }
    
    init(withUUID uuid:NSUUID, andMajor major: Int, andProximity proximity: CLProximity){
        super.init()
        self.minor = NSNumber(int: 1)
        self.major = NSNumber(integerLiteral: major)
        self.accuracy = CLLocationAccuracy(0.1)
        self.proximityUUID = uuid
        stubProximity = proximity
    }
    
    init(uuid:NSUUID, major: Int, minor: Int, proximity: CLProximity, accuracy: Double){
        super.init()
        self.proximityUUID = uuid
        self.minor = NSNumber(integerLiteral: minor)
        self.major = NSNumber(integerLiteral: major)
        self.accuracy = CLLocationAccuracy(accuracy)
        stubProximity = proximity
    }
    
    init(withUUID uuid:NSUUID, andMajor major: Int, andMinor minor: Int){
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
