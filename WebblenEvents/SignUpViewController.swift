//
//  SignUpViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit

class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate{


    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        self.registerButton.layer.cornerRadius = CGFloat(Float(5.0))
        
        setupFBLogin()
        
    }

    //FB Sign in button
    fileprivate func setupFBLogin(){
        
        let FBloginButton = FBSDKLoginButton()
        FBloginButton.delegate = self
        view.addSubview(FBloginButton)
        FBloginButton.frame = CGRect(x: 16, y: 525, width: view.frame.width - 32, height: 40)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func didPressRegister(_ sender: Any) {
        
        registerButton.isEnabled = false
        
        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: {(user, error) in
            
            if(error != nil){
                
                self.errorMessage.text = error?.localizedDescription
                
            }
            else{
                self.errorMessage.text = "Registration Successful"
                
                FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!, completion: {(user, error) in
                    
                    if(error == nil){
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("AMUSEMENT").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("ART").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("COMMUNITY").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("COMPETITION").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("CULTURE").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("EDUCATION").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("ENTERTAINMENT").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("FAMILY").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("FOODDRINK").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("GAMING").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("HEALTHFITNESS").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("MUSIC").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("NETWORKING").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("OUTDOORS").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("SHOPPING").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("SPORTS").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("TECHNOLOGY").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("THEATRE").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("FRATERNITYLIFE").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("SORORITYLIFE").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("PARTYDANCE").setValue(false)
                        
                        self.performSegue(withIdentifier: "SetupSegue", sender: nil)
                    }
                    
                })
                
            }
        })

    }


    @IBAction func informationEntered(_ sender: UITextField) {
        
        if((email.text?.characters.count)! > 0 && (password.text?.characters.count)! > 0 && (password.text)! == (confirmPassword.text)!){
            
            registerButton.isEnabled = true
            
        }
        else{
            
            registerButton.isEnabled = false
            
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: {(user, error) in
            
            if(error == nil){
                self.databaseRef.child("Users").child((user?.uid)!).child("Name").observeSingleEvent(of: .value, with: {(snapshot:FIRDataSnapshot) in
                    
                    if(!snapshot.exists())
                    {
                        
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("AMUSEMENT").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("ART").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("COMMUNITY").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("COMPETITION").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("CULTURE").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("EDUCATION").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("ENTERTAINMENT").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("FAMILY").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("FOODDRINK").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("GAMING").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("HEALTHFITNESS").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("MUSIC").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("NETWORKING").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("OUTDOORS").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("SHOPPING").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("SPORTS").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("TECHNOLOGY").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("THEATRE").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("FRATERNITYLIFE").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("SORORITYLIFE").setValue(false)
                        self.databaseRef.child("Users").child(user!.uid).child("interests").child("PARTYDANCE").setValue(false)
                        
                        self.performSegue(withIdentifier: "SetupSegue", sender: nil)
                    }
                    else{
                        self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    }
                    
                })
            }
            else if (result.isCancelled){
                
            }
            else{
                self.errorMessage.text = error?.localizedDescription
            }
            
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }



}
