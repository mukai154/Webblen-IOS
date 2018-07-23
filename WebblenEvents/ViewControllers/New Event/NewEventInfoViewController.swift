//
//  NewEventTitleViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/28/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class NewEventInfoController: UIViewController, UITextViewDelegate {

    //Firebase
    var currentUser = Auth.auth().currentUser
    var isEditingEvent = false
    
    //Event
    var event:EventPost?
    var eventTitle:String?
    var eventCaption:String?
    var eventDescription:String?
    
    //UI
    @IBOutlet weak var eventTitleField: UITextFieldX!
    @IBOutlet weak var eventCaptionField: UITextView!
    @IBOutlet weak var eventCaptionCount: UILabel!
    @IBOutlet weak var eventDescriptionField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventCaptionCount.isHidden = true
        //Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
    }

    @IBAction func didPressNext(_ sender: Any) {
        proceed()
    }
    
    //Caption Limit
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = eventCaptionField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 100
    }
    
    //Swipe Actions
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            proceed()
        }
    }
    
    //Validation
    func formError() -> Int{
        var formError = 0
        let title = self.eventTitleField.text
        let caption = self.eventCaptionField.text
        let description = self.eventDescriptionField.text
        if (title!.count < 5){
            formError = 1
        }
        else if (caption!.count < 10){
            formError = 2
        } else if (description!.count == 1000){
            formError = 3
        }
        return formError
    }
    
    func proceed(){
        let errCode = formError()
        
        if errCode == 1 {
            self.showBlurAlert(title: "Title Error", message: "Title Cannot Be Empty")
        } else if errCode == 2 {
            self.showBlurAlert(title: "Caption Error", message: "Caption is not descriptive")
        } else if errCode == 3 {
            self.showBlurAlert(title: "Description Error", message: "Description Limit Error")
        } else {
            let title = self.eventTitleField.text
            let caption = self.eventCaptionField.text
            let description = self.eventDescriptionField.text
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.newEvent.title = title!
                    parentVC.newEvent.caption = caption!
                    parentVC.newEvent.description = description!
                    parentVC.displayPageForIndex(index: 1)
                }
            }
        }
    }
    

}
