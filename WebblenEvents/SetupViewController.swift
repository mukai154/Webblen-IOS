//
//  SetupViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SetupViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    var user:AnyObject?
    
    var rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
    self.user = FIRAuth.auth()?.currentUser

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func didTapGetStarted(_ sender: Any) {
        
        let username = self.rootRef.child("Usernames").child(self.username.text!).observeSingleEvent(of: .value, with: {(snapshot: FIRDataSnapshot) in
        
            if(!snapshot.exists()){
                
                self.rootRef.child("Users").child(self.user!.uid).child("Name").setValue(self.username.text!.capitalized)
                self.rootRef.child("Usernames").child(self.username.text!.capitalized).setValue(self.user?.uid)
                
                self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                
            }
            else{
                self.errorMessage.text = "Sorry, but that name is being used :("
            }
            
        })
        
    }
    
    

}
