import Foundation

protocol BeaconAddressLoaderProtocol {
    func beaconAddressesLoaded(_ address: [[String: String]]?)
}

class BeaconAddressLoader: SpreadsheetAPIDelegate {
    
    typealias SpreadsheetApiFactoryBlock = (SpreadsheetAPIDelegate)-> SpreadsheetAPI
    
    var delegate: BeaconAddressLoaderProtocol?
    
    static let ParsingAddressFailed = "ParsingAddressFailed"
    
    fileprivate let apiFactoryBlock: SpreadsheetApiFactoryBlock
    fileprivate let localFileName: String
    fileprivate let queue = DispatchQueue(label: "BeaconAddressLoader", attributes: [])
    fileprivate let errorHandler: ErrorHandlingProtocol
    fileprivate let fileService: FileService
    
    fileprivate lazy var spreadsheetApi: SpreadsheetAPI = {
        [unowned self] in
        return self.apiFactoryBlock(self)
    }()
    
    // object lifecyle (delegate and api class strong reference cycle)
    init(spreadsheetApiCreate: @escaping SpreadsheetApiFactoryBlock,
         localFileName: String,
         fileService: FileService,
         errorHandler: ErrorHandlingProtocol)
    {
        self.apiFactoryBlock = spreadsheetApiCreate
        self.localFileName = localFileName
        self.errorHandler = errorHandler
        self.fileService = fileService
    }
    
    func loadBeaconAddressFromSheetWithID(_ sheetID: String) -> Void {
        queue.async {
            self.spreadsheetApi.saveRemoteSheetFileWithId(sheetID, locallyToFile: self.localFileName)
        }
    }

    // MARK: SpreadsheetAPIDelegate
    func localFile(_ localName: String, isUpToDateWithRequestedFile remoteName: String) {
        self.delegate?.beaconAddressesLoaded(self.parseAddresses())
    }
    
    func requestedFile(_ remoteName: String, hasBeenSavedLocallyToFile localName: String){
        self.delegate?.beaconAddressesLoaded(self.parseAddresses())
    }
    
    func requestingRemoteFileFailedWithError(_ error: NSError){
        errorHandler.handleError(error)
    }
    
    func fetchingRemoteFileFailedWithError(_ error: NSError) {
        errorHandler.handleError(error)
    }
    
    func fileCouldNotBeSavedTo(_ fileName: String){}
    
    // MARK: Private function
    fileprivate func parseAddresses() -> [[String:String]]? {
        var addresses: [[String: String]] = []
        do {
            let path = fileService.fullPathForFileName(localFileName)
            let parsedData = try CSV(name: path)
            addresses = parsedData.rows
        } catch {
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: BeaconAddressLoader.ParsingAddressFailed),
                                      object: self)
        }
        return addresses
    }
}
