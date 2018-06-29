//
//  NewEventTitleViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/28/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class NewEventInfoController: UIViewController {

    //Firebase
    var currentUser = Auth.auth().currentUser
    
    //Event
    var event:EventPost?
    var eventTitle:String?
    var eventCaption:String?
    
    //UI
    @IBOutlet weak var eventTitleField: UITextFieldX!
    @IBOutlet weak var eventCaptionField: UITextView!
    @IBOutlet weak var eventDescriptionField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentVC = self.parent {
            if let parentVC = parentVC as? NewEventPagingViewController {
               parentVC.nextBtn.isEnabled = true
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
