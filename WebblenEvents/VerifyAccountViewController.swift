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
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    
    //Firebase References
    var dataBaseRef = FIRDatabase.database().reference()
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
        self.currentUser = FIRAuth.auth()?.currentUser
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
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            
            
            if (chosePhoto1 == true){
            uploadedImage = true
            self.photo1.image = image
            chosePhoto1 = false
            
            }
            
            if (chosePhoto2 == true){
                uploadedImage = true
                self.photo2.image = image
                chosePhoto2 = false
            }
            
            if (chosePhoto3 == true){
                uploadedImage = true
                self.photo3.image = image
                chosePhoto3 = false
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didPressPhoto1(_ sender: Any) {
        
        chosePhoto1 = true
        selectPhotos()
        
    }
    
    @IBAction func didPressPhoto2(_ sender: Any) {
        
        chosePhoto2 = true
        selectPhotos()
    }
    
    @IBAction func didPressPhoto3(_ sender: Any) {
        
        chosePhoto3 = true
        selectPhotos()
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func selectPhotos(){
    
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
    }
    

}
