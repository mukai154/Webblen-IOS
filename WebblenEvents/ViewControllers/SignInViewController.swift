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
import NVActivityIndicatorView




class SignInViewController: UIViewController,  FBSDKLoginButtonDelegate{

    
    
    @IBOutlet var UXVIEW: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginBtn: UIButton!
    @IBOutlet weak var twitterLoginBtn: UIButton!
    

    @IBOutlet weak var noAccountButton: UIButton!
    
    var database = Firestore.firestore()
    var twitterSession: TWTRSession?
    
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
        startLoading()
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: {(user, error) in
            
            if(error == nil){
                self.database.collection("users").document((user?.uid)!).getDocument(completion: {(snapshot, error) in
                    if error != nil {
                        print(error)
                        self.stopLoading()
                    }
                    else {
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                    }
                })
            }
            else{
                self.stopLoading()
                self.errorMessage.text = error?.localizedDescription
            }
        })
    }

    @IBAction func didPressFBLogin(_ sender: Any) {
        startLoading()
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: ["public_profile"], from: self) {(result, error) in
            if let error = error {
                self.errorMessage.text = ("Failed to login: \(error.localizedDescription)")
                self.stopLoading()
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                self.stopLoading()
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if(error == nil){
                    self.database.collection("users").document((user?.uid)!).getDocument(completion: {(snapshot, error) in
                        if error != nil {
                            self.stopLoading()
                            print(error)
                        }
                        else {
                            self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                        }
                    })
                }
                else{
                    self.stopLoading()
                    self.errorMessage.text = error?.localizedDescription
                }
            })
        }
    }
    
    @IBAction func didPressTwitterLogin(_ sender: Any) {
        startLoading()
        TWTRTwitter.sharedInstance().logIn { (session, err) in
            if let err = err {
                self.showAlert(withTitle: "Twitter Authentication Failed", message: "\(err)")
                self.stopLoading()
                return
            }
            else {
                print(session)
                self.twitterSession = session
                self.signInWithTwitter()
            }
        }
    }
    
    func signInWithTwitter(){
        print("Signing in..")
        let credentials = TwitterAuthProvider.credential(withToken: (twitterSession?.authToken)!, secret: (twitterSession?.authTokenSecret)!)
            Auth.auth().signIn(with: credentials, completion: {(user, error) in
                if(error == nil){
                    print((user?.uid)!)
                    self.database.collection("users").document((user?.uid)!).getDocument(completion: {(snapshot, error) in
                        if error == nil {
                            self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                        }
                        else {
                            self.stopLoading()
                        }
                    })
                }
                else{
                    self.stopLoading()
                    self.errorMessage.text = error?.localizedDescription
                }
            })
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



