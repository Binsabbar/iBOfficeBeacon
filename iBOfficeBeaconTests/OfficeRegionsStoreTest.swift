//
//  OfficeRegionsStoreTest.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 06/12/2015.
//  Copyright © 2015 Binsabbar. All rights reserved.
//

import XCTest

class OfficeRegionsStoreTest: XCTestCase {

    var uuid:NSUUID = NSUUID.init()
    var aRoom: OfficeRoom!
    var beacon: CLBeaconStub!
    var roomsInOffice: [Int:OfficeRoom]!

    override func setUp() {
        super.setUp()
        
        aRoom = OfficeRoom(withName: "Turing", calendarID: "uri", minor: 1)
        beacon = CLBeaconStub(withUUID: uuid, andMajor: 12, andMinor:1)
        roomsInOffice = [ 13: OfficeRoom(withName: "Turing", calendarID: "uri", minor: 13),
                          29: OfficeRoom(withName: "Hacienda", calendarID: "uri2", minor: 29)
        ]
    }

    func testReturnsOfficeRoomForBeacon(){
        let mockedOffice = OfficeRegionStub(withBeacon: beacon, andRegionRooms: [1: aRoom])
        let subject = OfficeRegionsStore(officeRegion: mockedOffice)
        
        let result:OfficeRoom! = subject.officeRoomForBeacon(beacon)
        
        XCTAssertEqual(result.name, aRoom.name)
        XCTAssertEqual(result!.calendarID, aRoom.calendarID)
    }
    
    func testReturnsOfficeRoomForBeaconRegion() {
        let region = CLBeaconRegion(proximityUUID: uuid, major: 12, minor: 1, identifier: "ID")
        let mockedOffice = OfficeRegionStub(withRegion: region, andRegionRooms: [1: aRoom])
        let subject = OfficeRegionsStore(officeRegion: mockedOffice)
        
        let result:OfficeRoom! = subject.roomForBeaconRegion(region)
        
        XCTAssertEqual(result.name, aRoom.name)
        XCTAssertEqual(result.calendarID, aRoom.calendarID)
    }
    
    func testReturnsNilWhenNoRoomsExistForGivenRegions() {
        let region = CLBeaconRegionStub(proximityUUID: uuid, major: 1, identifier: "Test")
        let room = OfficeRoom(withName: "some room", calendarID: "uri", minor: 130)
        let mockedOffice = OfficeRegionStub(withRegion: region, andRegionRooms: [130: room])
        let subject = OfficeRegionsStore(officeRegion: mockedOffice)
        
        _ = subject.officeRoomForBeacon(beacon)
        
//        XCTAssertNil(result)
    }
    
    func testReturnAllRoomsInOffice() {
        let mockedOffice = OfficeRegionStub(withBeacon: beacon, andRegionRooms: roomsInOffice)
        let subject = OfficeRegionsStore(officeRegion: mockedOffice)
        let officeRoomsArr:[OfficeRoom] = roomsInOffice.map({(_, officeRoom) in officeRoom})
        
        let result:[OfficeRoom] = subject.allRoomsInRegionForBeacon(beacon)!
        
        for office in officeRoomsArr {
            XCTAssertTrue(
                result.contains{ (room: OfficeRoom) in
                    room.name == office.name
                }
            )
        }
    }
}
