//
//  NewEventDateViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/30/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftDate

class NewEventDateViewController: UIViewController {
    let dateFormatter = DateFormatter()
    
    //Outlets
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    //Event Date
    var eventDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
        //Calendar
        calendarView.selectDates([ Date() ])
    }

    @IBAction func didPressNext(_ sender: Any) {
        proceed()
    }
    
    //Validation
    func isValid() -> Bool{
        var isValid = true
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if eventDate + 1.day < Date() {
            isValid = false
        }
        return isValid
    }
    
    func proceed(){
        if isValid() {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.newEvent.startDate = dateFormatter.string(from: eventDate)
                    parentVC.displayPageForIndex(index: 4)
                }
            }
        } else {
            showBlurAlert(title: "Invalid Date", message: "Date Cannot Set in the Past")
        }
    }
    //Swipe Actions
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.displayPageForIndex(index: 2)
                }
            }
        } else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            proceed()
        }
    }
}

//Calendar
extension NewEventDateViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        let currentDate = Date() 
        let dateInAYear = Date() + 1.year
        let startDate = currentDate
        let endDate = dateInAYear
        let params = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return params
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let dateCell = cell as! CalendarCollectionViewCell
        sharedFunctionToConfigureCell(dateCell: dateCell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let dateCell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        sharedFunctionToConfigureCell(dateCell: dateCell, cellState: cellState, date: date)
        return dateCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let dateCell = cell as? CalendarCollectionViewCell else { return }
        dateCell.dateBackgroundView.isHidden = false
        dateCell.dateLabel.textColor = .white
        eventDate = date
        //print(eventDate!)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let dateCell = cell as? CalendarCollectionViewCell else { return }
        dateCell.dateBackgroundView.isHidden = true
        dateCell.dateLabel.textColor = .darkGray
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        dateFormatter.dateFormat = "yyyy"
        yearLbl.text = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "MMMM"
        monthLbl.text = dateFormatter.string(from: date!)
    }
    
    func sharedFunctionToConfigureCell(dateCell: CalendarCollectionViewCell, cellState: CellState, date: Date) {
        dateCell.dateLabel.text = cellState.text
        if cellState.isSelected {
            dateCell.dateBackgroundView.isHidden = false
            dateCell.dateLabel.textColor = .white
        } else {
            dateCell.dateBackgroundView.isHidden = true
            dateCell.dateLabel.textColor = .darkGray
        }
    }
}
