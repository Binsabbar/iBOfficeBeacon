import Foundation

class BeaconAddressMapper {

    
    fileprivate typealias officeInfo = (major: Int, minor:Int, office:String, room:String,
        calendarID: String)
    
    func mapAddresses(_ addresses: [[String:String]]) -> [OfficeAddress] {
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
    
    fileprivate func extractOfficeInfoFromAddress(_ address:[String: String]) -> officeInfo? {
        if let major = address["major"], let majorInt = Int(major),
               let minor = address["minor"], let minorInt = Int(minor),
               let room = address["room"], let office = address["office"],
               let calendarID = address["calendar id"] {
            
            return (majorInt, minorInt, office, room, calendarID)
        }
        return nil
    }
}
