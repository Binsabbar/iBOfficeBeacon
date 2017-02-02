import Foundation

class BeaconAddressMapper {

    
    private typealias officeInfo = (major: Int, minor:Int, office:String, room:String,
        calendarID: String)
    
    func mapAddresses(addresses: [[String:String]]) -> [OfficeAddress] {
        var offices = [OfficeAddress]()
        var officesHash = [Int: OfficeAddress]()
        
        addresses.forEach { (address) in
            if let info: officeInfo = extractOfficeInfoFromAddress(address) {
                if officesHash[info.major] == nil {
                    let newOffice = OfficeAddress(name: info.office, major: info.major)
                    officesHash[info.major] = newOffice
                    offices.append(newOffice)
                }
                
                let officeRoom = OfficeRoom(withName: info.room, calendarID: info.calendarID, minor: info.minor)
                officesHash[info.major]!.addRoom(officeRoom)
            }
        }
        
        return offices
    }
    
    private func extractOfficeInfoFromAddress(address:[String: String]) -> officeInfo? {
        if let major = address["major"], majorInt = Int(major),
               minor = address["minor"], minorInt = Int(minor),
               room = address["room"], office = address["office"],
               calendarID = address["calendar id"] {
            
            return (majorInt, minorInt, office, room, calendarID)
        }
        return nil
    }
}
