//
//  BeaconAddressMapperUnitTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 21/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import XCTest

class BeaconAddressMapperUnitTest: XCTestCase {

    var subject: BeaconAddressMapper!
    
    override func setUp() {
        super.setUp()
        subject = BeaconAddressMapper()
    }
    

    func testItMapsAddressIntoOfficeAddressObject() {
        let officesToBeMapped = parsedOfficeAddresses()
        let offices = subject.mapAddresses(officesToBeMapped)
        
        XCTAssertTrue(offices.count == 2)
        XCTAssertTrue(offices.first!.name == "Manchester")
        XCTAssertTrue(offices.last!.name == "London")
    }

    func testItMapsManchesterRoomsToManchesterOffice() {
        let officesToBeMapped = parsedOfficeAddresses()
        let offices = subject.mapAddresses(officesToBeMapped)
        let manchesterOffice = offices.first!

        XCTAssertTrue(manchesterOffice.major == 1)

        XCTAssertTrue(manchesterOffice.rooms.first?.beaconMinor == 2)
        XCTAssertTrue(manchesterOffice.rooms.first?.name == "Turing")
        XCTAssertTrue(manchesterOffice.rooms.first?.calendarID == "turing@someemail.com")
        
        XCTAssertTrue(manchesterOffice.rooms.last?.beaconMinor == 3)
        XCTAssertTrue(manchesterOffice.rooms.last?.name == "Factory")
        XCTAssertTrue(manchesterOffice.rooms.last?.calendarID == "factory@someemail.com")
    }
    
    func testItMapsLondonRoomsToLondonOffice() {
        let officesToBeMapped = parsedOfficeAddresses()
        let offices = subject.mapAddresses(officesToBeMapped)
        let LonodonOffice = offices.last!

        XCTAssertTrue(LonodonOffice.major == 4)
        
        XCTAssertTrue(LonodonOffice.rooms.first?.beaconMinor == 223)
        XCTAssertTrue(LonodonOffice.rooms.first?.name == "Hive")
        XCTAssertTrue(LonodonOffice.rooms.first?.calendarID == "hive@someemail.com")
    }
    
    private func parsedOfficeAddresses() -> [[String:String]]{
        return [
            [
                "major":"1",
                "minor":"2",
                "office":"Manchester",
                "room":"Turing",
                "calendar id":"turing@someemail.com"
            ],
            [
                "major":"1",
                "minor":"3",
                "office":"Manchester",
                "room":"Factory",
                "calendar id":"factory@someemail.com"
            ],
            [
                "major":"4",
                "minor":"223",
                "office":"London",
                "room":"Hive",
                "calendar id":"hive@someemail.com"
            ]
        ]
        
    }

}
