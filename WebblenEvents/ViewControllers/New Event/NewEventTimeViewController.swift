//
//  NewEventTimeViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 7/13/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import SwiftDate

class NewEventTimeViewController: UIViewController {

    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var noEndSwitch: UISwitch!
    
    //Variables
    var chosenDate = ""
    var eventStart = ""
    var eventEnd = ""
    var noEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }

    @IBAction func didPressNoEndSwitch(_ sender: Any) {
        if (noEndSwitch.isOn){
            endTimePicker.isEnabled = false
            endTimePicker.tintColor = UIColor.lightGray
            noEnd = true
        }
        else {
            endTimePicker.isEnabled = true
            endTimePicker.tintColor = UIColor.black
            noEnd = false
        }
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        proceed()
    }
    
    
    //Validation
//    func isValid() -> Bool{
//        var isValid = true
//
//        return isValid
//    }
    
    func proceed(){
        //Date Format
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        if (noEnd == true) {
            eventStart = formatter.string(from: startTimePicker.date)
            eventEnd = ""
        } else {
            eventStart = formatter.string(from: startTimePicker.date)
            eventEnd = formatter.string(from: endTimePicker.date)
            if (eventStart == eventEnd){
                eventEnd = ""
            }
        }
        if let parentVC = self.parent {
            if let parentVC = parentVC as? NewEventPagingViewController {
                parentVC.newEvent.startTime = eventStart
                parentVC.newEvent.endTime = eventEnd
                parentVC.displayPageForIndex(index: 5)
            }
        }
    }
    
    //Swipe Actions
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.displayPageForIndex(index: 3)
                }
            }
        } else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            proceed()
        }
  
    }

}
