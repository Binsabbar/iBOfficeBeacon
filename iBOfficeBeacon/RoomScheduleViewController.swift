//
//  RoomViewController.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 18/11/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import UIKit

class RoomScheduleViewController: UIViewController {

    @IBOutlet weak var roomNameLabel: UITextField!
    @IBOutlet weak var roomStatusLabel: UILabel!
    @IBOutlet weak var scheduleTimeInfoLabel: UILabel!
    @IBOutlet weak var bookRoomButton: UIBlurredBorderedButton!
    @IBOutlet weak var scheduleDetailsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorLabel: UILabel!
    
    fileprivate let wiring = Wiring.sharedWiring
    fileprivate var calendarService: CalendarService!
    fileprivate var gradientView: GradientView!
    
    var officeRoom: OfficeRoom?
    var currentSchedule: ScheduleProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarService = wiring.calendarService()
        scheduleDetailsLabel.numberOfLines = 0
        gradientView = self.view as! GradientView
        
        
        bookRoomButton.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicatorLabel.isHidden = true
        toggleAllLabelsVisibilityTo(hidden: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawTopAndBottomBorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkRoomStatus()
    }
    
    fileprivate func startActivityIndicatorWithMessage(_ message: String) {
        activityIndicatorLabel.text = message
        activityIndicatorLabel.isHidden = false
        activityIndicator.startAnimating()
    }
    
    @IBAction func bookRoomTouched(_ sender: AnyObject) {
        toggleAllLabelsVisibilityTo(hidden: true)
        startActivityIndicatorWithMessage("Booking a room ...")
        bookRoomButton.isHidden = true
        Thread.excuteAfterDelay(1) {
            self.calendarService.bookRoomAsync(self.officeRoom!, withSchedule: self.currentSchedule!) { (result) in
                if(result) {
                    self.checkRoomStatus()
                } else {
                    let alert = UIAlertController(title: "Booking a Room",
                                                  message: "An error occured while booking the room. Please try again later.",
                                                  preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.checkRoomStatus()
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func checkRoomStatus() {
        if let room = officeRoom, room.beaconMinor != 0 {
            roomNameLabel.text = room.name
            roomNameLabel.isHidden = false

            if room.isUknown {
                scheduleDetailsLabel.text = "This room is not registered in the app"
                scheduleDetailsLabel.isHidden = false
                return
            }
            startActivityIndicatorWithMessage("Checking room status ...")
            Thread.excuteAfterDelay(1){
                self.calendarService.findScheduleForRoom(room) { (currentSchedule) in
                        self.activityIndicator.stopAnimating()
                        self.activityIndicatorLabel.isHidden = true
                        self.setupScheduleLabelsWithSchedule(currentSchedule!, room: room)
                    }
            }
        } else {
            toggleAllLabelsVisibilityTo(hidden: true)
        }
    }
    
    //MARK: - UI Tasks
    fileprivate func setupScheduleLabelsWithSchedule(_ schedule: ScheduleProtocol, room: OfficeRoom) {
        let scheduleVM = RoomScheduleViewModel(model: schedule, room: room)
        
        roomStatusLabel.text = scheduleVM.statusLabelTitle
        
        scheduleTimeInfoLabel.attributedText = scheduleVM.scheduleTimeInfoAttributedString
        scheduleTimeInfoLabel.backgroundColor = scheduleVM.scheduleTimeInfoBackgroundColor
        
        bookRoomButton.colorForNormalState = scheduleVM.bookButtonColorForNormalState
        bookRoomButton.colorForTapState = scheduleVM.bookButtonColorForTapState
        bookRoomButton.isHidden = scheduleVM.shouldHideBookButton
        bookRoomButton.titleLabel?.textColor = scheduleVM.bookButtonBackgroundColor
        
        scheduleDetailsLabel.text = scheduleVM.scheduleLabelTitle
        
        gradientView.topColor = scheduleVM.gradientViewTopColor
        gradientView.middleColor = scheduleVM.gradientViewMiddleColor
        gradientView.bottomColor = scheduleVM.gradientViewBottomColor
        
        currentSchedule = schedule
        
        toggleAllLabelsVisibilityTo(hidden: false)
    }
    
    fileprivate func toggleAllLabelsVisibilityTo(hidden: Bool) {
        roomNameLabel.isHidden = hidden
        roomStatusLabel.isHidden = hidden
        scheduleDetailsLabel.isHidden = hidden
        scheduleTimeInfoLabel.isHidden = hidden
        scheduleDetailsLabel.isHidden = hidden
    }
    
    fileprivate func drawTopAndBottomBorder() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: roomNameLabel.frame.size.height - 2,
                                        width: roomNameLabel.frame.size.width, height: 1.0);
        bottomBorder.backgroundColor = UIColor.white.cgColor
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: roomNameLabel.frame.size.width, height: 1.0);
        topBorder.backgroundColor = UIColor.white.cgColor
        
        roomNameLabel.layer.addSublayer(bottomBorder)
        roomNameLabel.layer.addSublayer(topBorder)
    }
}
