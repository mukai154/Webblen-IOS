//
//  VerifyAccountViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 9/12/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class VerifyAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var accountEmail: UITextField!
    @IBOutlet weak var accountPhone: UITextField!
    @IBOutlet weak var image1: UIButton!
    @IBOutlet weak var image2: UIButton!
    @IBOutlet weak var image3: UIButton!

    
    //Firebase References
    var dataBaseRef = Database.database().reference()
    var currentUser: AnyObject?
    
    //Variable
    var uid : String?
    var username : String?
    var email : String?
    var phoneNumber : String?
    var selectedPhoto1 : UIImage?
    var selectedPhoto2 : UIImage?
    var selectedPhoto3 : UIImage?
    var chosePhoto1 = false
    var chosePhoto2 = false
    var chosePhoto3 = false
    var uploadPhoto1 = false
    var uploadPhoto2 = false
    var uploadPhoto3 = false
    
    var imagePicker = UIImagePickerController()
    
    var uploadedImage = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        
        //image picker
        imagePicker.delegate = self
        
        //Grab UID
        self.currentUser = Auth.auth().currentUser
        self.uid = currentUser?.uid


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Function after photo has been selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if (chosePhoto1 == true){
            
                uploadedImage = true
                
                uploadPhoto1 = true
            
                print(chosePhoto1)
            
                self.image1.setBackgroundImage(image, for: .normal)
                
                chosePhoto1 = false
            }
            
            if (chosePhoto2 == true){
                
                uploadedImage = true
                
                uploadPhoto2 = true
                
                self.image2.setBackgroundImage(image, for: .normal)
                
                chosePhoto2 = false
            }
            
            if (chosePhoto3 == true){
                
                uploadedImage = true
                
                uploadPhoto3 = true
                
                
                self.image3.setBackgroundImage(image, for: .normal)
                
                chosePhoto3 = false
            }
            
            
            

        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didPressPhoto1(_ sender: Any) {
        
        chosePhoto1 = true
        
        actionForPhotoSource()

        
    }
    
    @IBAction func didPressPhoto2(_ sender: Any) {
        
        chosePhoto2 = true
        actionForPhotoSource()
    }
    
    @IBAction func didPressPhoto3(_ sender: Any) {
        
        chosePhoto3 = true
        actionForPhotoSource()
        
    }
    
    
    //Cancel
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Functions for selecting image from library or camera
    func actionForPhotoSource(){
        let actionSheet = UIAlertController(title: "Upload Photo", message: "Choose photo source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
                
            }
            else {
                print("camera not utilized")
            }
            
            }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    //Submit Photos
    @IBAction func didTapSubmit(_ sender: Any) {
        
        //Check for images & Event Key & Link Storage & Prepare Segue
        let key = self.dataBaseRef.child("toBeVerified").childByAutoId().key
        let storage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com")
        let imageRef = storage.child("toBeVerified").child(currentUser!.uid as! String).child("\(key).jpg")
        
        //Alert for missing category
        if ((self.accountName.text?.isEmpty)! || (self.accountEmail.text?.isEmpty)! || (self.accountPhone.text?.isEmpty)! ){
            let alert = UIAlertController(title: "Information Missing", message: "Please Fill All Fields", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
        //Different Photo Uploads
        if (uploadPhoto1 == true){
        let imageData1 = UIImageJPEGRepresentation(self.image1.backgroundImage(for: .normal)!, 0.6)
        let uploadPhoto = imageRef.putData(imageData1!, metadata: nil) {(metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                }
            else {
                    //Post URL is available, post it with the event
                    let downloadURL = (metadata!.downloadURL()?.absoluteString)
                self.dataBaseRef.child("toBeVerified").child(self.uid!).child("image1").setValue(downloadURL)

            }
        }
        }
         
        if (uploadPhoto2 == true){
        let imageDate2 = UIImageJPEGRepresentation(self.image2.backgroundImage(for: .normal)!, 0.6)
            let uploadPhoto = imageRef.putData(imageDate2!, metadata: nil) {(metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    //Post URL is available, post it with the event
                    let downloadURL = (metadata!.downloadURL()?.absoluteString)
                    self.dataBaseRef.child("toBeVerified").child(self.uid!).child("image2").setValue(downloadURL)
            }
        }
        }
            
        if (uploadPhoto3 == true){
        let imageDate3 = UIImageJPEGRepresentation(self.image3.backgroundImage(for: .normal)!, 0.6)
            let uploadPhoto = imageRef.putData(imageDate3!, metadata: nil) {(metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    //Post URL is available, post it with the event
                    let downloadURL = (metadata!.downloadURL()?.absoluteString)
                    self.dataBaseRef.child("toBeVerified").child(self.uid!).child("image3").setValue(downloadURL)
                }
            }
    }
        }
    }

            
}
