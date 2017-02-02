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
    
    private let wiring = Wiring.sharedWiring
    private var calendarService: CalendarService!
    private var gradientView: GradientView!
    
    var officeRoom: OfficeRoom?
    var currentSchedule: RoomSchedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarService = wiring.calendarService()
        scheduleDetailsLabel.numberOfLines = 0
        gradientView = self.view as! GradientView
        
        
        bookRoomButton.hidden = true
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicatorLabel.hidden = true
        toggleAllLabelsVisibilityTo(hidden: true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        drawTopAndBottomBorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkRoomStatus()
    }
    
    private func startActivityIndicatorWithMessage(message: String) {
        activityIndicatorLabel.text = message
        activityIndicatorLabel.hidden = false
        activityIndicator.startAnimating()
    }
    
    @IBAction func bookRoomTouched(sender: AnyObject) {
        toggleAllLabelsVisibilityTo(hidden: true)
        startActivityIndicatorWithMessage("Booking a room ...")
        bookRoomButton.hidden = true
        NSThread.excuteAfterDelay(1) {
            self.calendarService.bookRoomAsync(self.officeRoom!, withSchedule: self.currentSchedule!) { (result) in
                if(result) {
                    self.checkRoomStatus()
                } else {
                    let alert = UIAlertController(title: "Booking a Room",
                                                  message: "An error occured while booking the room. Please try again later.",
                                                  preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: { (_) in
                        self.checkRoomStatus()
                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func checkRoomStatus() {
        if let room = officeRoom where room.beaconMinor != 0 {
            roomNameLabel.text = room.name
            roomNameLabel.hidden = false

            if room.isUknown {
                scheduleDetailsLabel.text = "This room is not registered in the app"
                scheduleDetailsLabel.hidden = false
                return
            }
            startActivityIndicatorWithMessage("Checking room status ...")
            NSThread.excuteAfterDelay(1){
                self.calendarService.findScheduleForRoom(room) { (currentSchedule) in
                        self.activityIndicator.stopAnimating()
                        self.activityIndicatorLabel.hidden = true
                        self.setupScheduleLabelsWithSchedule(currentSchedule!, room: room)
                    }
            }
        } else {
            toggleAllLabelsVisibilityTo(hidden: true)
        }
    }
    
    //MARK: - UI Tasks
    private func setupScheduleLabelsWithSchedule(schedule: RoomSchedule, room: OfficeRoom) {
        let scheduleVM = RoomScheduleViewModel(model: schedule, room: room)
        
        roomStatusLabel.text = scheduleVM.statusLabelTitle
        
        scheduleTimeInfoLabel.attributedText = scheduleVM.scheduleTimeInfoAttributedString
        scheduleTimeInfoLabel.backgroundColor = scheduleVM.scheduleTimeInfoBackgroundColor
        
        bookRoomButton.colorForNormalState = scheduleVM.bookButtonColorForNormalState
        bookRoomButton.colorForTapState = scheduleVM.bookButtonColorForTapState
        bookRoomButton.hidden = scheduleVM.shouldHideBookButton
        bookRoomButton.titleLabel?.textColor = scheduleVM.bookButtonBackgroundColor
        
        scheduleDetailsLabel.text = scheduleVM.scheduleLabelTitle
        
        gradientView.topColor = scheduleVM.gradientViewTopColor
        gradientView.middleColor = scheduleVM.gradientViewMiddleColor
        gradientView.bottomColor = scheduleVM.gradientViewBottomColor
        
        currentSchedule = schedule
        
        toggleAllLabelsVisibilityTo(hidden: false)
    }
    
    private func toggleAllLabelsVisibilityTo(hidden hidden: Bool) {
        roomNameLabel.hidden = hidden
        roomStatusLabel.hidden = hidden
        scheduleDetailsLabel.hidden = hidden
        scheduleTimeInfoLabel.hidden = hidden
        scheduleDetailsLabel.hidden = hidden
    }
    
    private func drawTopAndBottomBorder() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, roomNameLabel.frame.size.height - 2,
                                        roomNameLabel.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.whiteColor().CGColor
        
        let topBorder = CALayer()
        topBorder.frame = CGRectMake(0.0, 0.0, roomNameLabel.frame.size.width, 1.0);
        topBorder.backgroundColor = UIColor.whiteColor().CGColor
        
        roomNameLabel.layer.addSublayer(bottomBorder)
        roomNameLabel.layer.addSublayer(topBorder)
    }
}
