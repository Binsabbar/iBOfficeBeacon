

import Foundation

class BeaconAddressStore: BeaconAddressLoaderProtocol {
    static let OfficesUpdatedNotificationID = "OfficesUpdatedNotificationID"
    
    fileprivate var loader: BeaconAddressLoader!
    fileprivate var mapper: BeaconAddressMapper!
    fileprivate var addressSheetID: String!
    fileprivate(set) var _offices: [OfficeAddress]?
    
    var currentOffice: OfficeAddress?
    
    init() { }
    
    init(loader: BeaconAddressLoader, mapper: BeaconAddressMapper, addressSheetID: String) {
        self.loader = loader
        self.mapper = mapper
        self.addressSheetID = addressSheetID
        self.loader.delegate = self
        _ = offices
    }
    
    //MARK: Instance Public Methods
    func refreshAdddresses() {
        self.loader.loadBeaconAddressFromSheetWithID(addressSheetID)
    }

    func roomWithMajor(_ major: Int, minor: Int) -> OfficeRoom? {
        if let office = currentOffice, office.major == major {
            return findRoomWithMinor(minor, inOffice: office)
        } else if let office = officeWithMajor(major) {
            return findRoomWithMinor(minor, inOffice: office)
        }
        return nil
    }
    
    //MARK: Private methods
    fileprivate func officeWithMajor(_ major: Int) -> OfficeAddress? {
        if let offices = self.offices {
            for office in offices {
                if office.major == major {
                    currentOffice = office
                    return office
                }
            }
        }
        return nil
    }
    
    fileprivate func findRoomWithMinor(_ minor: Int, inOffice office: OfficeAddress) -> OfficeRoom? {
        for room in office.rooms {
            if(room.beaconMinor == minor) {
                return room
            }
        }
        return nil
    }
    
    fileprivate(set) var offices: [OfficeAddress]? {
        get {
            if _offices == nil {
                self.loader.loadBeaconAddressFromSheetWithID(addressSheetID)
                return nil
            }
            return _offices
        }
        
        set {
            _offices = newValue
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: BeaconAddressStore.OfficesUpdatedNotificationID),
                                      object: self)
        }
    }
    
    //MARK: BeaconAddressLoaderProtocol
    func beaconAddressesLoaded(_ addresses: [[String : String]]?) {
        if let loadedAddresses = addresses {
            offices = mapper.mapAddresses(loadedAddresses)
        }
    }
}
