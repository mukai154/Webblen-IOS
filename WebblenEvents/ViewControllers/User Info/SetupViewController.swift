//
//  SetupViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class SetupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //UI Element
    @IBOutlet var UXVIEW: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var profilePicImgBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    
    //Firebase & User Data
    var user = Auth.auth().currentUser
    var database = Firestore.firestore()
    var profilePicStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/profile_pics")
    var userID:String?
    var formattedName:String?
    var userImg:UIImage?
    var imagePicker = UIImagePickerController()
    var uploadedImage = false
    var userExists = false
    
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
        
        //*** INITIALIZE
        //Firebase
        removeOldUserData()
        
        //image picker
        imagePicker.delegate = self
        
        //UI Styling
        self.userProfilePic.layer.cornerRadius = self.userProfilePic.frame.size.width / 2;
        self.nextButton.layer.cornerRadius = 15
        self.userID = user?.uid

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SetupInterestsSegue"){
            let setupInterests = segue.destination as! UserTagsViewController
            if (!userExists){
               setupInterests.settingUp = true
            }
        }
    }
    

    //Username Validation
    func nameIsValid() -> Bool{
        var isValid = true
        let name = username.text?.lowercased()
        formattedName = name?.replacingOccurrences(of: " ", with: "")
        if formattedName == nil {
            isValid = false
            self.errorMessage.text = "Username Cannot Be Blank"
        } else if formattedName!.count > 12 {
            isValid = false
            self.errorMessage.text = "Username Cannot Be More Than 24 Characters Long"
        } else if formattedName!.count < 3 {
            isValid = false
            self.errorMessage.text = "Username Must Be At Least 3 Characters Long"
        }
        return isValid
    }
    
    //Remove Old Data
    func removeOldUserData(){
        database.collection("users").document(user!.uid).getDocument(completion: {(snapshot, error) in
            if (snapshot?.exists)!{
                self.userExists = true
                let oldUsername = snapshot?.data()!["username"] as? String
                if oldUsername != nil {
                    self.database.collection("usernames").document(oldUsername!).delete()
                }
            }
        })
    }
    
    //Function after photo has been selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            uploadedImage = true
            userProfilePic.contentMode = .scaleAspectFill
            userProfilePic.image = image
            userProfilePic.clipsToBounds = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //Photo Action Button
    @IBAction func selectImageFromPhotos(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        startLoading()
        if nameIsValid(){
            if uploadedImage {
                database.collection("usernames").document(formattedName!).getDocument(completion: {(snapshot, error) in
                    if (snapshot?.exists)! {
                        self.stopLoading()
                        self.errorMessage.text = "Sorry, This Name is Already Taken."
                    }
                    else {
                        if self.userExists {
                            let imageData = UIImageJPEGRepresentation(self.userProfilePic.image!, 1.0)
                            let imageRef = self.profilePicStorage.child((self.user?.uid)! + ".jpg")
                            let uploadImage = imageRef.putData(imageData!, metadata: nil) {(metadata, error) in
                                if error != nil {
                                    self.stopLoading()
                                    self.errorMessage.text = "Issue uploading, Please Try Again"
                                    return
                                }
                                imageRef.downloadURL(completion: {(url, error) in
                                    if let url = url {
                                        let usernameRef = self.database.collection("usernames")
                                        usernameRef.document(self.formattedName!).setData([
                                            "uid": self.user?.uid
                                            ])
                                        let userDocRef = self.database.collection("users")
                                        userDocRef.document(self.userID!).updateData(["username":self.formattedName!, "profile_pic":url.absoluteString])
                                        self.userExists = true
                                        self.performSegue(withIdentifier: "SetupInterestsSegue", sender: nil)
                                    }
                                })
                            }
                        } else {
                            
                            let imageData = UIImageJPEGRepresentation(self.userProfilePic.image!, 1.0)
                            let imageRef = self.profilePicStorage.child((self.user?.uid)! + ".jpg")
                            let uploadImage = imageRef.putData(imageData!, metadata: nil) {(metadata, error) in
                                if error != nil {
                                    self.stopLoading()
                                    self.errorMessage.text = "Issue uploading, Please Try Again"
                                    return
                                }
                                imageRef.downloadURL(completion: {(url, error) in
                                    if let url = url {
                                        let newUser: [String: Any] = [
                                            "eventPoints": 0,
                                            "tags": [],
                                            "isOver18": false,
                                            "isOver21": false,
                                            "isVerified": false,
                                            "uid": self.userID!,
                                            "username": self.formattedName!,
                                            "profile_pic": url.absoluteString,
                                            "blockedUsers": []
                                        ]
                                        let userDocRef = self.database.collection("users")
                                        userDocRef.document(self.userID!).setData(newUser)
                                        let usernameRef = self.database.collection("usernames")
                                        usernameRef.document(self.username.text!).setData([
                                            "uid": self.user?.uid
                                            ])
                                        self.userExists = false
                                        self.performSegue(withIdentifier: "SetupInterestsSegue", sender: nil)
                                    }
                                })
                            }
                        }
                    }
                })
            } else {
                self.stopLoading()
                self.errorMessage.text = "Please Upload an Image for Your Account"
            }
        } else {
            self.stopLoading()
        }
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


