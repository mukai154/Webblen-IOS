//
//  DateViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 8/7/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    //Outlets
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var noEndSwitch: UISwitch!
    @IBOutlet weak var setDateTimeButton: UIButton!
    
    //Variables
    var chosenDate = "date"
    var eventStart = "5:45PM"
    var eventEnd = "end"
    var noEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didPressSetDate(_ sender: Any) {
        
        //Date Format
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        chosenDate = formatter.string(from: eventDatePicker.date)
        formatter.dateFormat = "h:mm a"
        
        //Send Data Back
        if let presenter = presentingViewController as? NewEventViewController{

            presenter.eventDate = chosenDate
            
            if (noEnd == true) {
                
                eventStart = formatter.string(from: startTimePicker.date)
                presenter.eventTime = eventStart
                presenter.dateTimeButton.setTitle(chosenDate + " | " + eventStart, for: .normal)
            }
            else {
   
                eventStart = formatter.string(from: startTimePicker.date)
                eventEnd = formatter.string(from: endTimePicker.date)
                
                if (eventStart == eventEnd){
                    presenter.eventTime = eventStart
                    presenter.dateTimeButton.setTitle(chosenDate + " | " + eventStart, for: .normal)
                    
                }
                else{
                    
                presenter.eventTime = eventStart + "-" + eventEnd
                
                presenter.dateTimeButton.setTitle(chosenDate + " | " + eventStart + " - " + eventEnd, for: .normal)
                }
            }
            
        }
        dismiss(animated: true, completion: nil)
        
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

    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
