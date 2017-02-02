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

    static let sharedWiring = Wiring(application: UIApplication.sharedApplication())
    
    var application: UIApplication
    
    // MARK: Private instances
    private var _beaconClient: ESTBeaconManager!
    private var _beaconClientForBackgroundManager: ESTBeaconManager!
    private var _beaconAddressLoader: BeaconAddressLoader!
    private var _beaconAddressMapper: BeaconAddressMapper!
    private var _beaconAddressStore: BeaconAddressStore!
    private var _beaconManager: BeaconManager!
    
    private var _localNotificationService: LocalNotificationService!
    private var _settings: AppSettings!
    
    private var _googleCalendarService: GTLRCalendarService!
    private var _calendarService: CalendarService!
    private var _calendarClient: CalendarClient!
    
    private var _googleDriveService: GTLRDriveService!
    private var _fileService: FileService!
    
    private var _authController: AuthController!
    private var _appUpdateController: AppUpdateController!
    private var _locationServiceAuthzController: LocationServiceAuthzController!
    private var _bluetoothController: BluetoothController!
    private var _bluetoothManager: CBPeripheralManager!
    private var _errorAlertController: ErrorAlertController!
    private var _googleAuthorizationErrorHandler: GoogleAuthorizationErrorHandler!
    private var _logoutController: LogoutController!
    
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
    
    private func fileService() -> FileService {
        if _fileService == nil {
            _fileService = FileService()
        }
        return _fileService
    }
    
    private func SpreadsheetAPIFactoryBlock() -> BeaconAddressLoader.SpreadsheetApiFactoryBlock {
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
        return RoomScheduleCoordinator()
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
            let manager = BITHockeyManager.sharedHockeyManager().updateManager
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
    private func beaconClientForBackgroundManager() -> ESTBeaconManager {
        if(_beaconClientForBackgroundManager == nil){
            _beaconClientForBackgroundManager = ESTBeaconManager.init()
        }
        return _beaconClientForBackgroundManager
    }
    
    private func beaconManagerClient() -> ESTBeaconManager {
        if(_beaconClient == nil){
            _beaconClient = ESTBeaconManager.init()
        }
        return _beaconClient
    }
}
