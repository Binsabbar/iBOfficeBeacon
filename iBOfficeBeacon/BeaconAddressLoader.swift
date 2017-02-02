import Foundation

protocol BeaconAddressLoaderProtocol {
    func beaconAddressesLoaded(address: [[String: String]]?)
}

class BeaconAddressLoader: SpreadsheetAPIDelegate {
    
    typealias SpreadsheetApiFactoryBlock = (SpreadsheetAPIDelegate)-> SpreadsheetAPI
    
    var delegate: BeaconAddressLoaderProtocol?
    
    static let ParsingAddressFailed = "ParsingAddressFailed"
    
    private let apiFactoryBlock: SpreadsheetApiFactoryBlock
    private let localFileName: String
    private let queue = dispatch_queue_create("BeaconAddressLoader", nil)
    private let errorHandler: ErrorHandlingProtocol
    private let fileService: FileService
    
    private lazy var spreadsheetApi: SpreadsheetAPI = {
        [unowned self] in
        return self.apiFactoryBlock(self)
    }()
    
    // object lifecyle (delegate and api class strong reference cycle)
    init(spreadsheetApiCreate: SpreadsheetApiFactoryBlock,
         localFileName: String,
         fileService: FileService,
         errorHandler: ErrorHandlingProtocol)
    {
        self.apiFactoryBlock = spreadsheetApiCreate
        self.localFileName = localFileName
        self.errorHandler = errorHandler
        self.fileService = fileService
    }
    
    func loadBeaconAddressFromSheetWithID(sheetID: String) -> Void {
        dispatch_async(queue) {
            self.spreadsheetApi.saveRemoteSheetFileWithId(sheetID, locallyToFile: self.localFileName)
        }
    }

    // MARK: SpreadsheetAPIDelegate
    func localFile(localName: String, isUpToDateWithRequestedFile remoteName: String) {
        self.delegate?.beaconAddressesLoaded(self.parseAddresses())
    }
    
    func requestedFile(remoteName: String, hasBeenSavedLocallyToFile localName: String){
        self.delegate?.beaconAddressesLoaded(self.parseAddresses())
    }
    
    func requestingRemoteFileFailedWithError(error: NSError){
        errorHandler.handleError(error)
    }
    
    func fetchingRemoteFileFailedWithError(error: NSError) {
        errorHandler.handleError(error)
    }
    
    func fileCouldNotBeSavedTo(fileName: String){}
    
    // MARK: Private function
    private func parseAddresses() -> [[String:String]]? {
        var addresses: [[String: String]] = []
        do {
            let path = fileService.fullPathForFileName(localFileName)
            let parsedData = try CSV(name: path)
            addresses = parsedData.rows
        } catch {
            NSNotificationCenter.defaultCenter()
                .postNotificationName(BeaconAddressLoader.ParsingAddressFailed,
                                      object: self)
        }
        return addresses
    }
}
