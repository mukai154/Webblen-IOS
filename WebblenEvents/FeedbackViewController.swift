//
//  FeedbackViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/26/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feedInput: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    var feedBack: String?
    var dataBaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.submitButton.layer.cornerRadius = CGFloat(5.0)

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        self.feedInput.layer.borderColor = UIColor.lightGray.cgColor
        self.feedInput.layer.borderWidth = 0.5
        self.feedInput.layer.cornerRadius = CGFloat(Float(5.0))
        

        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    //
    @IBAction func didPressSubmit(_ sender: Any) {
        let key = self.dataBaseRef.child("Feedback").childByAutoId().key
        
        if ((feedInput.text?.characters.count)! > 30){
        self.dataBaseRef.child("Feedback").child(key).setValue(feedInput.text)
        
        let alert = UIAlertController(title: "Thanks!", message: "We'll look at your feedback. It's people like you that help make this app become better and better.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in

        self.performSegue(withIdentifier: "homeSegue4", sender: nil)
            
        })

        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        }
            
        else{
            
            let alert = UIAlertController(title: "Feedback Description Error", message: "Please be more descriptive with your feedback", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
