//
//  SetupViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class SetupViewController: UIViewController {

    @IBOutlet weak var username: UITextField!

    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    var user = Auth.auth().currentUser
    var userID:String?
    
    var database = Firestore.firestore()
    var changingName = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorMessage.isHidden = true
        self.userID = user?.uid

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nameValidation(){
        if username.text == nil {
            self.errorMessage.isHidden = false
            self.errorMessage.text = "Name Cannot Be Blank"
        }
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        
        let newUser: [String: Any] = [
            "eventPoints": 0,
            "interests": [],
            "isOver18": false,
            "isOver21": false,
            "isVerified": false,
            "uid": self.userID!,
            "username": self.username.text!,
            "blockedUsers": []
        ]
        
        database.collection("usernames").document(username.text!).getDocument(completion: {(snapshot, error) in
            if (snapshot?.exists)! {
                self.errorMessage.isHidden = false
                self.errorMessage.text = "Sorry, this Name is taken :("
            }
            else {
                if self.username.text!.count > 2{
                let userDocRef = self.database.collection("users")
                userDocRef.document(self.userID!).setData(newUser)
                let usernameRef = self.database.collection("usernames")
                usernameRef.document(self.username.text!).setData([
                    "uid": self.user?.uid
                    ])
                }
                else if self.username.text!.count < 2 {
                    self.showAlert(withTitle: "Username error", message: "Please set a sufficient username")
                }
                else {
                self.performSegue(withIdentifier: "SetupInterestsSegue", sender: nil)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SetupInterestsSegue"){
            let setupInterests = segue.destination as! InterestSetupViewController
            setupInterests.settingUp = true
        }
    }
    
}


