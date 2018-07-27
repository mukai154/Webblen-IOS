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
    @IBOutlet weak var captionPlaceholder: UILabel!
    @IBOutlet weak var eventCaptionField: UITextView!
    @IBOutlet weak var eventCaptionCount: UILabel!
    @IBOutlet weak var eventDescriptionField: UITextView!
    @IBOutlet weak var eventDescriptionCount: UILabel!
    @IBOutlet weak var descriptionPlaceholder: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventCaptionField.delegate = self
        eventDescriptionField.delegate = self
        //Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
    }

    @IBAction func didPressNext(_ sender: Any) {
        proceed()
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
        } else if caption!.count > 140 {
            formError = 4
        } else if description!.count > 300 {
            formError = 5
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
        } else if errCode == 4 {
            self.showBlurAlert(title: "Caption Limit Error", message: nil)
        } else if errCode == 5 {
            self.showBlurAlert(title: "Description Limit Error", message: nil)
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
    
    func textViewDidChange(_ textView: UITextView) { //Handle
        if textView == eventCaptionField {
            
            let captionText = eventCaptionField.text ?? ""
            let captionTextCount = captionText.count
            if captionTextCount == 0 {
                captionPlaceholder.isHidden = false
            } else {
                captionPlaceholder.isHidden = true
            }
            let captionCharactersLeft = 140 - captionTextCount
            if captionCharactersLeft > 0 {
                eventCaptionCount.text = String(captionCharactersLeft)
                eventCaptionCount.textColor = .lightGray
            } else {
                eventCaptionCount.text = String(captionCharactersLeft)
                eventCaptionCount.textColor = .red
            }
            
        } else if textView == eventDescriptionField {
            let descriptionText = eventDescriptionField.text ?? ""
            let descriptionTextCount = descriptionText.count
            if descriptionTextCount == 0 {
                descriptionPlaceholder.isHidden = false
            } else {
                descriptionPlaceholder.isHidden = true
            }
            let descriptionCharactersLeft = 300 - descriptionTextCount
            if descriptionCharactersLeft > 0 {
                eventDescriptionCount.text = String(descriptionCharactersLeft)
                eventDescriptionCount.textColor = .lightGray
            } else {
                eventDescriptionCount.text = String(descriptionCharactersLeft)
                eventDescriptionCount.textColor = .red
            }
        }
        
    }
}
    


