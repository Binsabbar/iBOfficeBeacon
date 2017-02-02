import Foundation

protocol GenericOfficeRegion {
    var regionUUID: NSUUID {get}
    var regionMajorID: Int {get}
    var regionRooms: [Int:OfficeRoom]{get}
}
