//
//  NewEventViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/5/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import IQKeyboardManagerSwift
import NVActivityIndicatorView

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
    @IBOutlet weak var eventPriceHelp: UIButton!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var eventInfoHeighConstraint: NSLayoutConstraint!
    
    //Firebase References
    var dataBase = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    //Variables
    var username: String?
    var eventAddress = ""
    var eventDate = ""
    var eventTime = ""
    var eCheckTitle: String?
    var eCheckDesc: String?
    var uploadedImage = false
    var pathToImage = ""
    var eventImage: UIImageView?
    var notifyDistance = ""
    var eventKey : String?
    var editKey : String?
    var event18 = false
    var event21 = false
    var studentsOnly = false
    var lat : Double?
    var lon : Double?
    var editingEvent = false
    var eventPaid = false
    var eventRadius : Double?
    var eventVerified = false
    var notificationOnly = false
    var image : UIImage?
    
    var eventCategory = "Event Categories"
    var eventCategories : [String] = []

    
    
    var helpCircle = UIImage(named: "help-circle")?.withRenderingMode(.alwaysTemplate)

    
    var imagePicker = UIImagePickerController()
    
        var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-147), y: (yAxis-135), width: 300, height: 300)
        loadingView = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
        self.view.addSubview(loadingView)
        
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
        
        
        //image picker
        imagePicker.delegate = self


        //Event Title Style
        self.eventTitleField.delegate = self
        self.eventTitleField.layer.borderColor = UIColor.lightGray.cgColor
        self.eventTitleField.layer.borderWidth = 0.5
        self.eventTitleField.layer.cornerRadius = CGFloat(Float(5.0))
        
        //Event Description Field Style
        self.eventDescriptionField.delegate = self
        self.eventDescriptionField.textContainerInset = UIEdgeInsetsMake(10,0,10,0)
        self.eventDescriptionField.text = "Event Info"
        self.eventDescriptionField.textColor = UIColor.lightGray
        
        
        //Database Handler
        self.dataBase.collection("users").document((currentUser?.uid)!).getDocument(completion: {(snapshot, error) in
            if !(snapshot?.exists)! {
                self.performSegue(withIdentifier: "SetupSegue", sender: nil)
            }
            else if error != nil{
                print(error)
            }
            else {
                self.username = snapshot?.data()["username"] as! String
            }
        })
        
        if (self.editingEvent == true){
            
            let eventRef = dataBase.collection("events").document(eventKey!)
            eventRef.getDocument(completion: {(event, error) in
                if let event = event {
                    self.eventTitleField.text = event.data()["title"] as! String
                    self.eventDescriptionField.text = event.data()["description"] as! String
                    self.eventDate = event.data()["date"] as! String
                    self.eventTime = event.data()["time"] as! String
                    self.dateTimeButton.setTitle(self.eventDate + " | " + self.eventTime, for: .normal)
                    self.eventCategories = event.data()["categories"] as! [String]
                    self.chooseEventCategoryButton.setTitle(self.eventCategories.joined(separator: ", "), for: .normal)
                    self.pathToImage = event.data()["pathToImage"] as! String
                    if self.pathToImage != "" {
                        let url = NSURL(string: self.pathToImage)
                        self.eventImage?.sd_setImage(with: url as! URL)
                        let backImage = self.eventImage?.image
                        self.imageSelectButton.setImage(backImage, for: .normal)
                        
                    }
                    self.event18 = event.data()["event18"] as! Bool
                    self.event21 = event.data()["event21"] as! Bool
                    self.notificationOnly = event.data()["notificationOnly"] as! Bool
                    if (self.event18 == true){
                        self.modifyNotification.setTitle("18+ Event", for: .normal)
                    }
                    else if (self.event21 == true){
                        self.modifyNotification.setTitle("21+ Event", for: .normal)
                    }
                    else if (self.notificationOnly == true){
                        self.modifyNotification.setTitle("Notification Only", for: .normal)
                    }
                    else if (self.notificationOnly == true && self.event18 == true){
                        self.modifyNotification.setTitle("Notification Only, 18+ Event", for: .normal)
                    }
                    else if (self.notificationOnly == true && self.event21 == true){
                        self.modifyNotification.setTitle("Notification Only, 21+ Event", for: .normal)
                    }
                    else {
                        self.modifyNotification.setTitle("Event Filter Settings", for: .normal)
                    }
                    self.eventAddress = event.data()["address"] as! String
                    self.eventRadius = event.data()["radius"] as! Double
                    self.locationButton.setTitle(self.eventAddress + " | " + String(Int(self.eventRadius!)) + " Meters", for: .normal)
                    self.lat = event.data()["lat"] as! Double
                    self.lon = event.data()["lon"] as! Double
                    if self.eventRadius! < 10000 {
                        self.eventPriceLabel.text = "Event Total: $34.99"
                    }
                    if self.eventRadius! < 8500 {
                        self.eventPriceLabel.text = "Event Total: $29.99"
                    }
                    if self.eventRadius! < 6000 {
                        self.eventPriceLabel.text = "Event Total: $26.99"
                    }
                    if self.eventRadius! < 3100 {
                        self.eventPriceLabel.text = "Event Total: $24.99"
                    }
                    if self.eventRadius! < 2000 {
                        self.eventPriceLabel.text = "Event Total: $19.99"
                    }
                    if self.eventRadius! < 1000 {
                        self.eventPriceLabel.text = "Event Total: $14.99"
                    }
                    if self.eventRadius! < 600 {
                        self.eventPriceLabel.text = "Event Total: $9.99"
                    }
                    if self.eventRadius! < 400 {
                        self.eventPriceLabel.text = "Event Total: $4.99"
                    }
                    if self.eventRadius! < 275 {
                        self.eventPriceLabel.text = "Event Total: $2.99"
                    }
                }
                else {
                    print("doc does not exist")
                }
            })
            
            }
        
        eventPriceHelp.setImage(helpCircle, for: .normal)
        eventPriceHelp.tintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        
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

        loadingView.startAnimating()
        
        //Get Location Coordinates
        convertAddressToLatAndLong()
        let newEventReference = dataBase.collection("events").document()

        
        //VALIDATION
        if (self.eventTitleField.text!.count < 5){
            showAlert(withTitle: "Event Title Error", message: "Please be more descriptive.")
            loadingView.stopAnimating()
        }
        else if (self.eventDescriptionField.text!.count < 30){
            showAlert(withTitle: "Event Description Error", message: "Please do a better job of describing the event.")
            loadingView.stopAnimating()
        }
        else if (eventDate == "" || eventTime == ""){
            showAlert(withTitle: "Event Date/Time Error", message: "Please check the date of your event")
            loadingView.stopAnimating()
        }
        else if (eventAddress == "" || !(eventAddress.contains("Fargo, ND"))){
            showAlert(withTitle: "Event Address Error", message: "Please make an event within Fargo, ND.")
            loadingView.stopAnimating()
        }
        else if (eventCategories.isEmpty){
            showAlert(withTitle: "Event Categories", message: "Please choose at lease one category for your event.")
            loadingView.stopAnimating()
        }
        else if (uploadedImage == true){
        
            if isEditing == false {
            let imageStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/events")
            let imageRef = imageStorage.child("events").child((currentUser?.uid)!).child("\(newEventReference.documentID).jpg")
            
            let imageData = UIImageJPEGRepresentation(self.imageSelectButton.backgroundImage(for: .normal)!, 1.0)
            let uploadImage = imageRef.putData(imageData!, metadata: nil) {(metadata, error) in
                if error != nil {
                    self.showAlert(withTitle: "Event Upload Error", message: "Error occurred while uploading event")
                    return
                }
                imageRef.downloadURL(completion: {(url, error) in
                    if let url = url {
                        newEventReference.setData([
                            "title": self.eventTitleField.text!,
                            "address": self.eventAddress,
                            "date": self.eventDate,
                            "description": self.eventDescriptionField.text,
                            "categories": self.eventCategories,
                            "eventKey": newEventReference.documentID,
                            "lat": self.lat!,
                            "lon": self.lon!,
                            "paid": false,
                            "pathToImage": url.absoluteString,
                            "radius": self.eventRadius,
                            "time": self.eventTime,
                            "author": self.username!,
                            "verified": self.eventVerified,
                            "views": 0,
                            "event18": self.event18,
                            "event21": self.event21,
                            "notificationOnly": self.notificationOnly,
                            "distanceFromUser": 0
                            ])
                        self.loadingView.stopAnimating()
                        self.uploadPost(currentKey: newEventReference.documentID)
                        }
                    })
                }
            }
            else {
                let imageStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/events")
                let imageRef = imageStorage.child("events").child((currentUser?.uid)!).child("\(self.eventKey).jpg")
                
                let imageData = UIImageJPEGRepresentation(self.imageSelectButton.backgroundImage(for: .normal)!, 1.0)
                let uploadImage = imageRef.putData(imageData!, metadata: nil) {(metadata, error) in
                    if error != nil {
                        self.showAlert(withTitle: "Event Upload Error", message: "Error occurred while uploading event")
                        return
                    }
                    imageRef.downloadURL(completion: {(url, error) in
                        if let url = url {
                            let updateEvent = self.dataBase.collection("events").document(self.eventKey!)
                            updateEvent.updateData([
                                "title": self.eventTitleField.text!,
                                "address": self.eventAddress,
                                "date": self.eventDate,
                                "description": self.eventDescriptionField.text,
                                "categories": self.eventCategories,
                                "lat": self.lat!,
                                "lon": self.lon!,
                                "pathToImage": url.absoluteString,
                                "radius": self.eventRadius,
                                "time": self.eventTime,
                                "author": self.username!,
                                "event18": self.event18,
                                "event21": self.event21,
                                "notificationOnly": self.notificationOnly,
                                ])
                            self.loadingView.stopAnimating()
                            self.uploadPost(currentKey: self.eventKey!)
                        }
                    })
                }
            }
            
        }
        else if (uploadedImage == false){
            if !(isEditing) {
            newEventReference.setData([
                "title": self.eventTitleField.text!,
                "address": self.eventAddress,
                "date": self.eventDate,
                "description": self.eventDescriptionField.text,
                "categories": self.eventCategories,
                "eventKey": newEventReference.documentID,
                "lat": self.lat!,
                "lon": self.lon!,
                "paid": false,
                "pathToImage": "",
                "radius": self.eventRadius,
                "time": self.eventTime,
                "author": self.username!,
                "verified": self.eventVerified,
                "views": 0,
                "event18": self.event18,
                "event21": self.event21,
                "notificationOnly": self.notificationOnly,
                "distanceFromUser": 0
                ])
            loadingView.stopAnimating()
            uploadPost(currentKey: newEventReference.documentID)
            }
            else {
                let updateEvent = self.dataBase.collection("events").document(self.eventKey!)
                updateEvent.updateData([
                    "title": self.eventTitleField.text!,
                    "address": self.eventAddress,
                    "date": self.eventDate,
                    "description": self.eventDescriptionField.text,
                    "categories": self.eventCategories,
                    "lat": self.lat!,
                    "lon": self.lon!,
                    "pathToImage": "",
                    "radius": self.eventRadius,
                    "time": self.eventTime,
                    "author": self.username!,
                    "event18": self.event18,
                    "event21": self.event21,
                    "notificationOnly": self.notificationOnly,
                    ])
                self.loadingView.stopAnimating()
                self.uploadPost(currentKey: self.eventKey!)
            }
        }
    }
    
    func uploadPost(currentKey: String){
        
        activityIndicator.stopAnimating()
        performSegue(withIdentifier: "confirmSegue", sender: currentKey)
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
