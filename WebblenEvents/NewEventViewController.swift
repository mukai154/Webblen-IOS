//
//  NewEventViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/5/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import CoreLocation
import IQKeyboardManagerSwift

class NewEventViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{



    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventDescriptionField: UITextView!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var dateTimeButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var imageSelectButton: UIButton!
    @IBOutlet weak var modifyNotification: UIButton!
    @IBOutlet weak var chooseEventCategoryButton: UIButton!
    @IBOutlet weak var eventTabLabel: UILabel!
    
    @IBOutlet weak var eventInfoHeighConstraint: NSLayoutConstraint!
    
    //Firebase References
    var dataBaseRef = FIRDatabase.database().reference()
    var currentUser: AnyObject?

    
    //Variables
    var username: String?
    var eventAddress = "address"
    var eventDate: String?
    var eventTime = "time"
    var eCheckTitle: String?
    var eCheckDesc: String?
    var uploadedImage = false
    var pathToImage = "null"
    var notifyDistance = ""
    var eventKey = "key"
    var editKey = "key"
    var event18 = false
    var event21 = false
    var lat : Double?
    var lon : Double?
    var editingEvent = false
    var eventPaid = false

    var image : UIImage?
    
    var eventCategory = "Choose Category"

    //var eventStart = "time"
    //var eventEnd = "time"
    
    var imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        IQKeyboardManager.sharedManager().enable = false
        
        //Done for inputs
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        eventTitleField.inputAccessoryView = toolBar
        eventDescriptionField.inputAccessoryView = toolBar
        
        let screenSize : CGRect = UIScreen.main.bounds
        eventInfoHeighConstraint.constant = screenSize.height * 0.20
        
        //modifyNotification.isEnabled = false
        activityIndicator.isHidden = true
        

        
        //image picker
        imagePicker.delegate = self


        
        //Event Title Style
        self.eventTitleField.layer.borderColor = UIColor.lightGray.cgColor
        self.eventTitleField.layer.borderWidth = 0.5
        self.eventTitleField.layer.cornerRadius = CGFloat(Float(5.0))
        
        //Event Description Field Style
        self.eventDescriptionField.delegate = self
        self.eventDescriptionField.textContainerInset = UIEdgeInsetsMake(10,0,10,0)
        self.eventDescriptionField.text = "Event Info"
        self.eventDescriptionField.textColor = UIColor.lightGray
        
        //Address Button

        

        
        
        //Database Handler
        self.currentUser = FIRAuth.auth()?.currentUser
        self.dataBaseRef.child("Users").child(self.currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot:FIRDataSnapshot) in
        
            let snapshot = snapshot.value as! [String: AnyObject]
            self.username = snapshot["Name"] as? String
        
        })
        
        if (self.editingEvent == true){
            self.dataBaseRef.child("Event").child(editKey).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let eDict = snapshot.value as? [String: AnyObject]{

                    self.eventTitleField.text = eDict["title"] as? String
                    self.eventDescriptionField.text = eDict["evDescription"] as! String

                    self.eventDate = eDict["date"] as! String
                    self.eventTime = eDict["time"] as! String
                    self.eventCategory = eDict["category"] as! String
                    self.eventAddress = eDict["address"] as! String
                    self.dateTimeButton.setTitle(self.eventDate! + " | " + self.eventTime, for: .normal)
                    self.chooseEventCategoryButton.setTitle(self.eventCategory, for: .normal)
                    self.eventTabLabel.text = "Edit Event"
                    self.locationButton.setTitle(self.eventAddress, for: .normal)
                    self.createEventButton.setTitle("Finish Editing", for: .normal)
                }
                
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Function after photo has been selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
           uploadedImage = true
            self.imageSelectButton.setBackgroundImage(image, for: .normal)
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //Photo Action Button
    @IBAction func selectImageFromPhotos(_ sender: Any) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }

    
    //Erase initial text when editing text view
    func textViewDidBeginEditing(_ textView: UITextView) {
       
        if (editingEvent == false){
        if (eventDescriptionField.textColor == UIColor.lightGray){
            eventDescriptionField.text = ""
            eventDescriptionField.textColor = UIColor.black
        }
        }
    }
    

    
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }




    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    

    

    @IBAction func didTapConfirm(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        //Get Location Coordinates
        convertAddressToLatAndLong()
        
        //Check for images & Event Key & Link Storage & Prepare Segue
        let key = self.dataBaseRef.child("Event").childByAutoId().key
        eventKey = key
        let storage = FIRStorage.storage().reference(forURL: "gs://webblen-events.appspot.com")
        let imageRef = storage.child("Event").child(currentUser!.uid).child("\(key).jpg")
        
        ///Uppercase title & description
        eCheckTitle = eventTitleField.text?.uppercased()
        eCheckDesc = eventDescriptionField.text?.uppercased()
        eventAddress = locationButton.title(for: .normal)!
        
        //Check for profanity
        if ((eCheckTitle?.contains("ASSHOLE"))! || (eCheckTitle?.contains("BONDAGE"))! || (eCheckTitle?.contains("BITCH"))! || (eCheckTitle?.contains("VAGINA"))! || (eCheckTitle?.contains("PENIS"))! || (eCheckTitle?.contains("BLOWJOB"))! || (eCheckTitle?.contains("EJACULATION"))! || (eCheckTitle?.contains("JERKOFF"))! || (eCheckTitle?.contains("HANDJOB"))! || (eCheckTitle?.contains("SHIT"))! || (eCheckTitle?.contains("INTERCOURSE"))! || (eCheckTitle?.contains("RAPE"))! || (eCheckDesc?.contains("DAMN"))! || (eCheckDesc?.contains("FUCK"))! || (eCheckDesc?.contains("BITCH"))! || (eCheckDesc?.contains("VAGINA"))! || (eCheckDesc?.contains("PENIS"))! || (eCheckTitle?.contains("BLOWJOB"))! || (eCheckDesc?.contains("EJACULATION"))! || (eCheckDesc?.contains("JERKOFF"))! || (eCheckDesc?.contains("HANDJOB"))! || (eCheckDesc?.contains("SHIT"))! || (eCheckDesc?.contains("INTERCOURSE"))! || (eCheckDesc?.contains("GROUPSEX"))! || (eCheckDesc?.contains("ORGY"))! || (eCheckDesc?.contains("NIGGER"))! || (eCheckDesc?.contains("ANUS"))!){
            
            activityIndicator.stopAnimating()
            
            //Alert for profanity
            let alert = UIAlertController(title: "Watch Yo Profanity", message: "Please show some class", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Ok, I'm Sorry", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        }
            //Alert for missing category
        else if(self.eventCategory == "Choose Category"){
            
            activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Category Missing", message: "Please choose a category for this event.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //Alert for missing category or not descriptive enough category
        else if ((self.eventDescriptionField.text?.characters.count)! < 30){
            
            activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Event Description Error", message: "Please be more specific about the details of this event.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
        
            //Alert for checking if event is in Fargo
        else if (!(eventAddress.contains("Fargo")) || eventAddress.contains("address")){
            
            activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Event Address Error", message: "Please select a location in Fargo, ND", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
            }
            
            //Check for event time
        else if (eventTime.contains("time")){
            
            activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Event Time Error", message: "Please set a time for the event", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
            
            //Check detail of event & upload info to firebase
        else if((eventTitleField.text?.characters.count)! > 0 && (eventDescriptionField.text?.characters.count)! > 30 && uploadedImage == true && (editingEvent == false)){
            
            
            //Lowers resolution of the image
            let imageData = UIImageJPEGRepresentation(self.imageSelectButton.backgroundImage(for: .normal)!, 0.6)
                
            let uploadPhoto = imageRef.put(imageData!, metadata: nil) {(metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                        
                    //Post URL is available, post it with the event
                    let downloadURL = (metadata!.downloadURL()?.absoluteString)!
                    
                    //print(self.pathToImage)
                
                        //Name Fixes
                        if (self.eventCategory == "Health & Fitness"){
                            self.eventCategory = "HEALTHFITNESS"
                        }
                        if (self.eventCategory == "Party/Dance"){
                            self.eventCategory = "PARTYDANCE"
                        }
                        if (self.eventCategory == "Food & Drink"){
                            self.eventCategory = "FOODDRINK"
                        }
                        
                        if(self.eventCategory == "College Life"){
                            self.eventCategory = "COLLEGELIFE"
                        }
                        
                        if(self.eventCategory == "Wine & Brew"){
                            self.eventCategory = "WINEBREW"
                        }
                        
                        if (self.eventCategory != "Choose Category"){
                            
                            //Database upload
                            self.dataBaseRef.child("Event").child(key).child("category").setValue(self.eventCategory.uppercased())
                            self.dataBaseRef.child("Event").child(key).child("date").setValue(self.eventDate)
                            self.dataBaseRef.child("Event").child(key).child("time").setValue(self.eventTime)
                            self.dataBaseRef.child("Event").child(key).child("address").setValue(self.eventAddress)
                            self.dataBaseRef.child("Event").child(key).child("evDescription").setValue(self.eventDescriptionField.text)
                            self.dataBaseRef.child("Event").child(key).child("title").setValue(self.eventTitleField.text)
                            self.dataBaseRef.child("Event").child(key).child("uid").setValue(self.currentUser!.uid)
                            self.dataBaseRef.child("Event").child(key).child("username").setValue(self.username)
                            self.dataBaseRef.child("Event").child(key).child("eventKey").setValue(key)
                            self.dataBaseRef.child("Event").child(key).child("radius").setValue(String(self.notifyDistance))
                            self.dataBaseRef.child("Event").child(key).child("paid").setValue("false")
                            
                            if (self.currentUser?.uid == "KFDuKYEoHbUmc1B0nsfbssON6zY2"){
                            self.dataBaseRef.child("Event").child(key).child("verified").setValue("true")
                            }
                            else {
                            self.dataBaseRef.child("Event").child(key).child("verified").setValue("false")
                            }
                            
                            self.dataBaseRef.child("Event").child(key).child("pathToImage").setValue(downloadURL)
                            self.dataBaseRef.child("LocationCoordinates").child(key).child("lat").setValue(self.lat)
                            self.dataBaseRef.child("LocationCoordinates").child(key).child("lon").setValue(self.lon)
                        }
                    self.uploadPost()
                }
            }
        }
        else if (((self.eventDescriptionField.text?.characters.count)! > 30) && (eventTitleField.text?.characters.count)! > 0  && (editingEvent == false)){
            
            
            //Name Fixes
            if (self.eventCategory == "Health & Fitness"){
                self.eventCategory = "HEALTHFITNESS"
            }
            if (self.eventCategory == "Party/Dance"){
                self.eventCategory = "PARTYDANCE"
            }
            if (self.eventCategory == "Food & Drink"){
                self.eventCategory = "FOODDRINK"
            }
            
            if(self.eventCategory == "College Life"){
                self.eventCategory = "COLLEGELIFE"
            }
            
            if(self.eventCategory == "Wine & Brew"){
                self.eventCategory = "WINEBREW"
            }
            
            if (self.eventCategory != "Choose Category"){
                
                //Database upload
                self.dataBaseRef.child("Event").child(key).child("category").setValue(self.eventCategory.uppercased())
                self.dataBaseRef.child("Event").child(key).child("date").setValue(self.eventDate)
                self.dataBaseRef.child("Event").child(key).child("time").setValue(self.eventTime)
                self.dataBaseRef.child("Event").child(key).child("address").setValue(self.eventAddress)
                self.dataBaseRef.child("Event").child(key).child("evDescription").setValue(self.eventDescriptionField.text)
                self.dataBaseRef.child("Event").child(key).child("title").setValue(self.eventTitleField.text)
                self.dataBaseRef.child("Event").child(key).child("uid").setValue(self.currentUser!.uid)
                self.dataBaseRef.child("Event").child(key).child("username").setValue(self.username)
                self.dataBaseRef.child("Event").child(key).child("eventKey").setValue(key)
                self.dataBaseRef.child("Event").child(key).child("radius").setValue(String(self.notifyDistance))
                self.dataBaseRef.child("Event").child(key).child("paid").setValue("false")
                if (self.currentUser?.uid == "KFDuKYEoHbUmc1B0nsfbssON6zY2"){
                    self.dataBaseRef.child("Event").child(key).child("verified").setValue("true")
                }
                else {
                    self.dataBaseRef.child("Event").child(key).child("verified").setValue("false")
                }
                self.dataBaseRef.child("Event").child(key).child("pathToImage").setValue("null")
                self.dataBaseRef.child("LocationCoordinates").child(key).child("lat").setValue(self.lat)
                self.dataBaseRef.child("LocationCoordinates").child(key).child("lon").setValue(self.lon)

            
            }
            uploadPost()
        }
        else if ((self.eventDescriptionField.text?.characters.count)! > 30) && (eventTitleField.text?.characters.count)! > 0  && (editingEvent == true){
            
            //Name Fixes
            if (self.eventCategory == "Health & Fitness"){
                self.eventCategory = "HEALTHFITNESS"
            }
            if (self.eventCategory == "Party/Dance"){
                self.eventCategory = "PARTYDANCE"
            }
            if (self.eventCategory == "Food & Drink"){
                self.eventCategory = "FOODDRINK"
            }
            
            if(self.eventCategory == "College Life"){
                self.eventCategory = "COLLEGELIFE"
            }
            
            if(self.eventCategory == "Wine & Brew"){
                self.eventCategory = "WINEBREW"
            }
            
            if (self.eventCategory != "Choose Category"){
                
                //Database upload
                self.dataBaseRef.child("Event").child(self.editKey).child("category").setValue(self.eventCategory.uppercased())
                self.dataBaseRef.child("Event").child(self.editKey).child("date").setValue(self.eventDate)
                self.dataBaseRef.child("Event").child(self.editKey).child("time").setValue(self.eventTime)
                self.dataBaseRef.child("Event").child(self.editKey).child("address").setValue(self.eventAddress)
                self.dataBaseRef.child("Event").child(self.editKey).child("evDescription").setValue(self.eventDescriptionField.text)
                self.dataBaseRef.child("Event").child(self.editKey).child("title").setValue(self.eventTitleField.text)
                self.dataBaseRef.child("Event").child(self.editKey).child("uid").setValue(self.currentUser!.uid)
                self.dataBaseRef.child("Event").child(self.editKey).child("username").setValue(self.username)
                self.dataBaseRef.child("Event").child(self.editKey).child("radius").setValue(String(self.notifyDistance))
                if (self.eventPaid == true){
                    self.dataBaseRef.child("Event").child(self.editKey).child("paid").setValue("true")
                    
                }
                else{
                    self.dataBaseRef.child("Event").child(self.editKey).child("paid").setValue("false")
                }
                if (self.currentUser?.uid == "KFDuKYEoHbUmc1B0nsfbssON6zY2"){
                    self.dataBaseRef.child("Event").child(self.editKey).child("verified").setValue("true")
                }
                else {
                    self.dataBaseRef.child("Event").child(self.editKey).child("verified").setValue("false")
                }
                self.dataBaseRef.child("Event").child(self.editKey).child("pathToImage").setValue("null")
                self.dataBaseRef.child("LocationCoordinates").child(self.editKey).child("lat").setValue(self.lat)
                self.dataBaseRef.child("LocationCoordinates").child(self.editKey).child("lon").setValue(self.lon)
            
            performSegue(withIdentifier: "doneEditingSegue", sender: nil)
            
        }
        }
        else if ((self.eventDescriptionField.text?.characters.count)! > 30) && (eventTitleField.text?.characters.count)! > 0  && (editingEvent == true) && (uploadedImage == true){
            //Lowers resolution of the image
            let imageData = UIImageJPEGRepresentation(self.imageSelectButton.backgroundImage(for: .normal)!, 0.6)
            
            let uploadPhoto = imageRef.put(imageData!, metadata: nil) {(metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    
                    //Post URL is available, post it with the event
                    let downloadURL = (metadata!.downloadURL()?.absoluteString)!
                    
                    //print(self.pathToImage)
                    
                    //Name Fixes
                    if (self.eventCategory == "Health & Fitness"){
                        self.eventCategory = "HEALTHFITNESS"
                    }
                    if (self.eventCategory == "Party/Dance"){
                        self.eventCategory = "PARTYDANCE"
                    }
                    if (self.eventCategory == "Food & Drink"){
                        self.eventCategory = "FOODDRINK"
                    }
                    
                    if(self.eventCategory == "College Life"){
                        self.eventCategory = "COLLEGELIFE"
                    }
                    
                    if(self.eventCategory == "Wine & Brew"){
                        self.eventCategory = "WINEBREW"
                    }
                    
                    if (self.eventCategory != "Choose Category"){
                        
                        //Database upload
                        self.dataBaseRef.child("Event").child(self.editKey).child("category").setValue(self.eventCategory.uppercased())
                        self.dataBaseRef.child("Event").child(self.editKey).child("date").setValue(self.eventDate)
                        self.dataBaseRef.child("Event").child(self.editKey).child("time").setValue(self.eventTime)
                        self.dataBaseRef.child("Event").child(self.editKey).child("address").setValue(self.eventAddress)
                        self.dataBaseRef.child("Event").child(self.editKey).child("evDescription").setValue(self.eventDescriptionField.text)
                        self.dataBaseRef.child("Event").child(self.editKey).child("title").setValue(self.eventTitleField.text)
                        self.dataBaseRef.child("Event").child(self.editKey).child("uid").setValue(self.currentUser!.uid)
                        self.dataBaseRef.child("Event").child(self.editKey).child("username").setValue(self.username)
                        self.dataBaseRef.child("Event").child(self.editKey).child("radius").setValue(String(self.notifyDistance))
                        if (self.eventPaid == true){
                            self.dataBaseRef.child("Event").child(self.editKey).child("paid").setValue("true")

                        }
                        else{
                            self.dataBaseRef.child("Event").child(self.editKey).child("paid").setValue("false")
                        }
                        
                        if (self.currentUser?.uid == "KFDuKYEoHbUmc1B0nsfbssON6zY2"){
                            self.dataBaseRef.child("Event").child(self.editKey).child("verified").setValue("true")
                        }
                        else {
                            self.dataBaseRef.child("Event").child(self.editKey).child("verified").setValue("false")
                        }
                        
                        self.dataBaseRef.child("Event").child(self.editKey).child("pathToImage").setValue(downloadURL)
                        self.dataBaseRef.child("LocationCoordinates").child(self.editKey).child("lat").setValue(self.lat)
                        self.dataBaseRef.child("LocationCoordinates").child(self.editKey).child("lon").setValue(self.lon)
                    }
                    self.performSegue(withIdentifier: "doneEditingSegue", sender: nil)
                }
            }
        }

    }
    
    func uploadPost(){
        
        activityIndicator.stopAnimating()
        performSegue(withIdentifier: "confirmSegue", sender: eventKey)
    }
    
    //Class to convert address from String to Coordinates
    func convertAddressToLatAndLong(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(eventAddress) {
            
            placemarks, error in
            let placemark = placemarks?.first
            self.lat = placemark?.location?.coordinate.latitude
            self.lon = placemark?.location?.coordinate.longitude
    
            }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if(segue.identifier == "confirmSegue"){
     let confirmController = segue.destination as! confirmPostViewController
        confirmController.eventKey = sender as! String
     }
    }
        
    func doneClicked(){
        view.endEditing(true)
    }
    


}
