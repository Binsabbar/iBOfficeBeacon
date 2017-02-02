

import Foundation

class BeaconAddressStore: BeaconAddressLoaderProtocol {
    static let OfficesUpdatedNotificationID = "OfficesUpdatedNotificationID"
    
    private var loader: BeaconAddressLoader!
    private var mapper: BeaconAddressMapper!
    private var addressSheetID: String!
    private(set) var _offices: [OfficeAddress]?
    
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

    func roomWithMajor(major: Int, minor: Int) -> OfficeRoom? {
        if let office = currentOffice
        where office.major == major {
            return findRoomWithMinor(minor, inOffice: office)
        } else if let office = officeWithMajor(major) {
            return findRoomWithMinor(minor, inOffice: office)
        }
        return nil
    }
    
    //MARK: Private methods
    private func officeWithMajor(major: Int) -> OfficeAddress? {
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
    
    private func findRoomWithMinor(minor: Int, inOffice office: OfficeAddress) -> OfficeRoom? {
        for room in office.rooms {
            if(room.beaconMinor == minor) {
                return room
            }
        }
        return nil
    }
    
    private(set) var offices: [OfficeAddress]? {
        get {
            if _offices == nil {
                self.loader.loadBeaconAddressFromSheetWithID(addressSheetID)
                return nil
            }
            return _offices
        }
        
        set {
            _offices = newValue
            NSNotificationCenter.defaultCenter()
                .postNotificationName(BeaconAddressStore.OfficesUpdatedNotificationID,
                                      object: self)
        }
    }
    
    //MARK: BeaconAddressLoaderProtocol
    func beaconAddressesLoaded(addresses: [[String : String]]?) {
        if let loadedAddresses = addresses {
            offices = mapper.mapAddresses(loadedAddresses)
        }
    }
}
