//
//  Wiring.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 09/12/2015.
//  Copyright © 2015 Binsabbar. All rights reserved.
//

import Foundation
import UIKit
//import HockeySDK

class Wiring: NSObject {

    static let sharedWiring = Wiring(application: UIApplication.shared)
    
    var application: UIApplication
    
    // MARK: Private instances
    fileprivate var _beaconClient: ESTBeaconManager!
    fileprivate var _beaconClientForBackgroundManager: ESTBeaconManager!
    fileprivate var _beaconAddressLoader: BeaconAddressLoader!
    fileprivate var _beaconAddressMapper: BeaconAddressMapper!
    fileprivate var _beaconAddressStore: BeaconAddressStore!
    fileprivate var _beaconManager: BeaconManager!
    
    fileprivate var _localNotificationService: LocalNotificationService!
    fileprivate var _settings: AppSettings!
    
    fileprivate var _googleCalendarService: GTLRCalendarService!
    fileprivate var _calendarService: CalendarService!
    fileprivate var _calendarClient: CalendarClient!
    
    fileprivate var _googleDriveService: GTLRDriveService!
    fileprivate var _fileService: FileService!
    
    fileprivate var _authController: AuthController!
    fileprivate var _googleAuthController: GoogleAuthController!
    fileprivate var _appUpdateController: AppUpdateController!
    fileprivate var _locationServiceAuthzController: LocationServiceAuthzController!
    fileprivate var _bluetoothController: BluetoothController!
    fileprivate var _bluetoothManager: CBPeripheralManager!
    fileprivate var _errorAlertController: ErrorAlertController!
    fileprivate var _googleAuthorizationErrorHandler: GoogleAuthorizationErrorHandler!
    fileprivate var _logoutController: LogoutController!
    
    // MARK: Public Function
    init(application: UIApplication) {
        self.application = application
        super.init()
    }
    
    func beaconManager() -> BeaconManager {
        if _beaconManager == nil {
            _beaconManager = BeaconManager(manager: beaconManagerClient())
        }
        return _beaconManager
    }
    
    func beaconService() -> TWBeaconService {
        return TWBeaconService(beaconManager: beaconManager(), beaconStore: beaconAddressStore(), appSettings: _settings)
    }
 
    func localNotificationService() -> LocalNotificationService {
        if _localNotificationService == nil {
            _localNotificationService = LocalNotificationService(application: application)
        }
        return _localNotificationService
    }
    
    func googleAuthorizationErrorHandler() -> GoogleAuthorizationErrorHandler {
        if _googleAuthorizationErrorHandler == nil {
            _googleAuthorizationErrorHandler = GoogleAuthorizationErrorHandler(authController: authorizationController())
        }
        return _googleAuthorizationErrorHandler
    }
    
    func beaconAddressLoader() -> BeaconAddressLoader {
        
        if _beaconAddressLoader == nil {
            _beaconAddressLoader = BeaconAddressLoader(spreadsheetApiCreate: SpreadsheetAPIFactoryBlock(),
                                                       localFileName: AppSettings.LOCAL_BEACON_ADDRESS_FILE_NAME,
                                                       fileService: fileService(),
                                                       errorHandler: googleAuthorizationErrorHandler())
        }
        return _beaconAddressLoader
    }
    
    fileprivate func fileService() -> FileService {
        if _fileService == nil {
            _fileService = FileService()
        }
        return _fileService
    }
    
    fileprivate func SpreadsheetAPIFactoryBlock() -> BeaconAddressLoader.SpreadsheetApiFactoryBlock {
        return { (delegate) in
            let driveClient = SheetDriveWrapper(withService: self.googleDriveService())
            let fileService = self.fileService()
            
            return SpreadsheetAPI(remoteFileClient: driveClient,
            fileService: fileService,
            delegate: delegate)
        }
    }
    
    func beaconAddressMapper() -> BeaconAddressMapper {
        if _beaconAddressMapper == nil {
            _beaconAddressMapper = BeaconAddressMapper()
        }
        return _beaconAddressMapper
    }

    func beaconAddressStore() -> BeaconAddressStore {
        if _beaconAddressStore == nil {
            let sheetID = settings().addressSheetID
            _beaconAddressStore = BeaconAddressStore(loader: beaconAddressLoader(), mapper: beaconAddressMapper(), addressSheetID: sheetID)
        }
        return _beaconAddressStore
    }
    
    func calendarService() -> CalendarService {
        if _calendarService == nil {
           _calendarService = CalendarService(calendarClient: calendarClient(),
                                              eventProcessor: calendarEventsProcessor(),
                                              coordinator: roomScheduleCoordinator())
        }
        return _calendarService
    }
    
    func calendarClient() -> CalendarClient {
        if _calendarClient == nil {
            _calendarClient = CalendarClient(withGoogleService: googleCalendarService(),
                                             errorHandler: googleAuthorizationErrorHandler())
        }
        return _calendarClient
    }
    
    func googleCalendarService() -> GTLRCalendarService {
        if(_googleCalendarService == nil) {
            _googleCalendarService = GTLRCalendarService()
        }
        return _googleCalendarService
    }
    
    func googleDriveService() -> GTLRDriveService {
        if(_googleDriveService == nil) {
            _googleDriveService = GTLRDriveService()
        }
        return _googleDriveService
    }
    
    func calendarEventsProcessor()-> CalendarEventsProcessor {
        return CalendarEventsProcessor()
    }
    
    func roomScheduleCoordinator() -> RoomScheduleCoordinator {
        return RoomScheduleCoordinator(timeslotsCalculator: FreeTimeslotCalculator())
    }
    
    func googleAuthorizationController() -> GoogleAuthController {
        if(_googleAuthController == nil) {
            let googleSettings = settings().googleSettings
            let services = [googleCalendarService(), googleDriveService()]
            _googleAuthController = GoogleAuthController(services: services, withSettings: googleSettings)
        }
        return _googleAuthController
    }
    
    func authorizationController() -> AuthController {
        if (_authController == nil) {
            let googleSettings = settings().googleSettings
            let services = [googleCalendarService(), googleDriveService()]
            _authController = AuthController(services: services, withSettings: googleSettings)
        }
        return _authController
    }
    
    func appUpdateController() -> AppUpdateController {
        if (_appUpdateController == nil) {
            let manager = BITHockeyManager.shared().updateManager
            _appUpdateController = AppUpdateController(updateManager: manager, settings: settings())
        }
        return _appUpdateController
    }
    
    func locationServiceAuthzController() -> LocationServiceAuthzController {
        if _locationServiceAuthzController == nil {
            _locationServiceAuthzController = LocationServiceAuthzController(beaconManager: beaconManagerClient())
        }
        return _locationServiceAuthzController
    }

    func bluetoothController() -> BluetoothController {
        if _bluetoothController == nil {
            _bluetoothController = BluetoothController()
            _bluetoothManager = CBPeripheralManager(delegate: _bluetoothController, queue: nil, options: nil)
        }
        return _bluetoothController
    }
 
    func errorAlertController() -> ErrorAlertController {
        if _errorAlertController == nil {
            _errorAlertController = ErrorAlertController()
        }
        return _errorAlertController
    }
    
    func settings() -> AppSettings {
        if _settings == nil {
            _settings = AppSettings(environment: AppSettings.BUILD_ENVIRONMENT)
        }
        return _settings
    }
    
    func logoutController() -> LogoutController {
        if _logoutController == nil {
            _logoutController = LogoutController(authController: authorizationController(),
                                                 fileService: fileService())
        }
        return _logoutController
    }
    
    //MARK: Private
    fileprivate func beaconClientForBackgroundManager() -> ESTBeaconManager {
        if(_beaconClientForBackgroundManager == nil){
            _beaconClientForBackgroundManager = ESTBeaconManager.init()
        }
        return _beaconClientForBackgroundManager
    }
    
    fileprivate func beaconManagerClient() -> ESTBeaconManager {
        if(_beaconClient == nil){
            _beaconClient = ESTBeaconManager.init()
        }
        return _beaconClient
    }
}
