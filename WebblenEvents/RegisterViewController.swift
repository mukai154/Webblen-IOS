//
//  RegisterViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/2/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var dataBaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    registerButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func didTapRegister(_ sender: Any) {
        
        
        registerButton.isEnabled = false
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: {(user, error) in
            
        
            
            if (error != nil){
                if (error!._code == 17999){
                    self.errorMessage.text = "Invalid Email Address"
                }
                else{
                    self.errorMessage.text = error?.localizedDescription
                }
            }
            else{
                self.errorMessage.text = "Registration Successful"
                FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!, completion: {(user, error) in
                
                    if (error == nil){
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("AMUSEMENT").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("ART").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("COMPETITION").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("CULTURE").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("COMMUNITY").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("EDUCATION").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("ENTERTAINMENT").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("FAMILY").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("FOOD DRINK").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("GAMING").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("HEALTH FITNESS").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("MUSIC").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("NETWORKING").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("OUTDOORS").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("SHOPPING").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("SPORTS").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("TECHNOLOGY").setValue(false)
                        self.dataBaseRef.child("Users").child(user!.uid).child("interests").child("THEATRE").setValue(false)
                        
                        self.performSegue(withIdentifier: "SetupSegue", sender: nil)
                    }
                })
                
            }
            
        })
        
        
    }
    
    //Check if information was entered to properly register user
    @IBAction func informationWasEntered(sender: UITextField) {
        
        if((email.text?.characters.count)! > 0 && (password.text?.characters.count)! > 6 && password.text == confirmPassword.text){
            
            registerButton.isEnabled = true
            
        }
        else {
            registerButton.isEnabled = false
        }
        
    }
}
