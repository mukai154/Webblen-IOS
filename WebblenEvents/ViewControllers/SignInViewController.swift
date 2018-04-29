//
//  SignInViewController.swift
//  
//
//  Created by Mukai Selekwa on 1/5/17.
//
//

import UIKit
import Firebase
import FBSDKLoginKit
import TwitterKit
import Fabric




class SignInViewController: UIViewController,  FBSDKLoginButtonDelegate{

    
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginBtn: UIButton!
    @IBOutlet weak var twitterLoginBtn: UIButton!
    

    @IBOutlet weak var noAccountButton: UIButton!
    
    var database = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        //Done for inputs
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        email.inputAccessoryView = toolBar
        password.inputAccessoryView = toolBar
        
        
        //Login buttons
        loginButton.layer.cornerRadius = 5
        fbLoginBtn.layer.cornerRadius = 5
        twitterLoginBtn.layer.cornerRadius = 5
        
        //setupGoogleLogin()
        
    

 
    
    }
    
    //FB Sign in button
    fileprivate func setupFBLogin(){
        
        let FBloginButton = FBSDKLoginButton()
        FBloginButton.delegate = self
        view.addSubview(FBloginButton)
        FBloginButton.frame = CGRect(x: 16, y: 435, width: view.frame.width - 32, height: 40)
    }
    
    /*
    //Google Sign in button
    fileprivate func setupGoogleLogin(){
        
        let googleButton = GIDSignInButton()
        googleButton.frame  = CGRect(x: 16, y: 435 + 45, width: view.frame.width - 32, height: 40)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    


    @IBAction func didPressLogin(_ sender: Any) {
    
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: {(user, error) in
            
            if(error == nil){
                self.database.collection("users").document((user?.uid)!).getDocument(completion: {(snapshot, error) in
                    if error != nil {
                        print(error)
                    }
                    else {
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                })
            }
            else{
                self.errorMessage.text = error?.localizedDescription
            }
        })
    }

    @IBAction func didPressFBLogin(_ sender: Any) {
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: ["public_profile"], from: self) {(result, error) in
            if let error = error {
                self.errorMessage.text = ("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if(error == nil){
                    self.database.collection("users").document((user?.uid)!).getDocument(completion: {(snapshot, error) in
                        if error != nil {
                            print(error)
                        }
                        else {
                            self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                        }
                    })
                }
                else{
                    self.errorMessage.text = error?.localizedDescription
                }
            })
        }
    }
    
    @IBAction func didPressTwitterLogin(_ sender: Any) {
        signInWithTwitter()
    }
    
    func signInWithTwitter(){
        func signIn(session: TWTRSession?, error: Error?) {
            if let error = error {
                print("Failed to login to Twitter: ", error.localizedDescription)
                return
            }            
            guard let token = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
            Auth.auth().signIn(with: credentials, completion: {(user, error) in
                if(error == nil){
                    self.database.collection("users").document((user?.uid)!).getDocument(completion: {(snapshot, error) in
                        if error != nil {
                            print(error)
                        }
                        else {
                            self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                        }
                    })
                }
                else{
                    self.errorMessage.text = error?.localizedDescription
                }
            })
        }
    }
    
    func signInWithFB(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: {(user, error) in
            if(error == nil){
                self.database.collection("users").document((user?.uid)!).getDocument(completion: {(snapshot, error) in
                    if error != nil {
                        print(error)
                    }
                    else {
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                })
            }
            else{
                self.errorMessage.text = error?.localizedDescription
            }
        })
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials, completion: {(user, error) in
            
            if(error == nil){
                self.database.collection("users").document((user?.uid)!).getDocument(completion: {(snapshot, error) in
                    if error != nil {
                        print(error)
                    }
                    else {
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                })
            }
            else if (result.isCancelled){
                self.errorMessage.text = "Facebook Authentication Cancelled"
            }
            else{
                self.errorMessage.text = error?.localizedDescription
            }
            
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    
    }
    
    func doneClicked(){
        view.endEditing(true)
    }

}



