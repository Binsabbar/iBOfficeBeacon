class FakeBeaconAddressStore:BeaconAddressStore {
    var fakeOffices: [GenericOfficeRegion]?
    
    func stubWithOffices(offices:[GenericOfficeRegion]) {
        fakeOffices = offices
    }
    
    struct fakeOffice:GenericOfficeRegion {
        var regionUUID: NSUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
        var regionMajorID: Int = 9891
        var regionRooms: [Int:OfficeRoom] = [111:OfficeRoom(withName:"fakeRoom",
            calendarID: "fakeID", minor: 111)]
    }
}
