//
//  SignUpViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import NVActivityIndicatorView

class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate{


    
    @IBOutlet var UXVIEW: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var userDocumentRef: DocumentReference!
    var loadingColor = UIColor.white
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Activity indicator setup
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
        loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: loadingColor, padding: 0)
        self.view.addSubview(loadingView)
        loadingView.stopAnimating()
        
        //FireStore Initializers

    
        
        //Done for inputs
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        email.inputAccessoryView = toolBar
        password.inputAccessoryView = toolBar
        confirmPassword.inputAccessoryView = toolBar
        

        
        self.registerButton.layer.cornerRadius = CGFloat(Float(5.0))
        
        //setupFBLogin()
        
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
    
    
    @IBAction func didPressRegister(_ sender: Any) {
        
        startLoading()
        
        registerButton.isEnabled = false
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: {(user, error) in
            
            if(error != nil){
                self.errorMessage.text = error?.localizedDescription
                self.registerButton.isEnabled = true
                self.stopLoading()
            }
            else{
                self.errorMessage.text = "Registration Successful"
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: {(user, error) in
                    if(error == nil){
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
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials, completion: {(user, error) in
            
            if(error == nil){

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
    
    @objc func doneClicked(){
        view.endEditing(true)
    }

    func startLoading(){
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.UXVIEW.alpha = 0.5
            self.loadingView.startAnimating()
        }, completion: nil)
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.UXVIEW.alpha = 1
            self.loadingView.stopAnimating()
        }, completion: nil)
    }


}
