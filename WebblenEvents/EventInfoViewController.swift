//
//  EventInfoViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/17/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import EventKit
import MapKit

class EventInfoViewController: UIViewController {

    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventUploadedPhoto: UIImageView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventCreator: UILabel!
    @IBOutlet weak var eventDescription: UITextView!

  
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var calendarIcon: UIImageView!
    
    @IBOutlet weak var bottomLineBreak: UIView!
    @IBOutlet weak var centerLineBreak: UIView!
    
    
    @IBOutlet weak var editEventButton: UIButton!
    @IBOutlet weak var deleteEventButton: UIButton!
    
    @IBOutlet weak var reportButton: UIBarButtonItem!

    @IBOutlet weak var imageHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    
    var imageName = "AMUSEMENT"
    var eDate = "01/01/2018"
    var eTime = "time"
    var eCat = "category"
    var eAddress = "address"
    var ePhoto = "string"
    var creator = "Admin"
    var evDescription = "description"
    var evTitle = "uid"
    var eventKey = "key"
    var editKey = "key"
    var eUid = "String"
    var ePayment = "false"
    var eventPaid = false
    
    var currentDate = Date()
    var formatter = DateFormatter()
    
    var currentUser:  AnyObject?
    var dataBaseRef: FIRDatabaseReference!
    var madeEvent = false

    var lat : Double?
    var lon : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize : CGRect = UIScreen.main.bounds
        imageHeightConstrain.constant = screenSize.height * 0.35
        descriptionHeightConstraint.constant = screenSize.height * 0.23

        if (screenSize.height <= 3.5){
            mapButton.isHidden = true
            calendarButton.isHidden = true
        }
        
        
        eventUploadedPhoto.layer.cornerRadius = 5
        eventUploadedPhoto.layer.masksToBounds = true
        
        eventDescription.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0)
        eventDescription.textColor = UIColor.lightGray
        self.editEventButton.layer.cornerRadius = CGFloat(5.0)
        self.deleteEventButton.layer.cornerRadius = CGFloat(5.0)

        
        self.editEventButton.isHidden = true
        self.editEventButton.isEnabled = false
        self.deleteEventButton.isHidden = true
        self.deleteEventButton.isEnabled = false

        
        dataBaseRef = FIRDatabase.database().reference()
        self.currentUser = FIRAuth.auth()?.currentUser
        self.editKey = self.eventKey
        
        self.dataBaseRef.child("Event").child(eventKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let eDict = snapshot.value as? [String: AnyObject]{
                self.eventImage.image = UIImage(named: (eDict["category"] as? String)!)
                self.eventTitle.text = eDict["title"] as? String
                self.eventCreator.text = eDict["username"] as? String
                self.eventDescription.text = eDict["evDescription"] as! String
                self.evDescription = eDict["evDescription"] as! String
                self.evTitle = eDict["title"] as! String
                self.eDate = eDict["date"] as! String
                self.eTime = eDict["time"] as! String
                self.eCat = eDict["category"] as! String
                self.eAddress = eDict["address"] as! String
                self.ePhoto = eDict["pathToImage"] as! String
                self.ePayment = eDict["paid"] as! String
                
                if (self.ePhoto != "null"){
                let url = NSURL(string: self.ePhoto)
                self.eventUploadedPhoto.sd_setImage(with: url! as URL)
                }
                else {
                self.eventUploadedPhoto.isHidden = true
                self.imageViewHeightConstraint.constant = 0
                }
                self.eUid = eDict["uid"] as! String
                let eUsername = eDict["username"] as! String
                if (self.eUid == self.currentUser?.uid || self.currentUser?.uid == "KFDuKYEoHbUmc1B0nsfbssON6zY2" ){
                    if(self.eCat != "WARNING"){
                    self.editEventButton.isHidden = false
                    self.editEventButton.isEnabled = true

                    }
                    self.calendarButton.isEnabled = false
                    self.calendarIcon.isHidden = true
                    self.mapButton.isEnabled = false
                    self.mapIcon.isHidden = true
                    self.deleteEventButton.isHidden = false
                    self.deleteEventButton.isEnabled = true
                    self.madeEvent = true
                    self.bottomLineBreak.isHidden = true
                    self.centerLineBreak.isHidden = true
                }
                if (self.ePayment == "true"){
                    self.eventPaid = true
                }
                
            }
        
        })
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
        
        eventUploadedPhoto.isUserInteractionEnabled = true
        
        eventUploadedPhoto.addGestureRecognizer(imageTap)
        
        // Do any additional setup after loading the view.
        var sysInfo = utsname()
        uname(&sysInfo)
        let machine = Mirror(reflecting: sysInfo.machine)
        let identifier = machine.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        self.platformType(platform: identifier as NSString)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressReportButton(_ sender: Any) {
        if (madeEvent == true){
            
            let alert = UIAlertController(title: "Event Options", message: "You Made This Event.", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if (madeEvent == false && self.eUid != "KFDuKYEoHbUmc1B0nsfbssON6zY2"){
            
            let alert = UIAlertController(title: "Event Options", message: "Report the Event for Offensive Content or Block Whomever Created It?", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Back", style: .cancel, handler: nil)
            
            let thankDismiss = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                
                self.performSegue(withIdentifier: "homeSegue2", sender: nil)
                
            })
            
            let thankAlert = UIAlertController(title: "Report Submitted", message: "Thank You for Submitting Your Report. We'll Address This Issue As Soon As Possible. Block the User to No Longer View Events By Them", preferredStyle: .alert)
            
            thankAlert.addAction(thankDismiss)
            
            
            let blockAction = UIAlertAction(title: "Block User", style: .default, handler: { action in
                
                self.dataBaseRef.child("Users").child((self.currentUser?.uid)!).child("Blocked Users").child(self.eUid).setValue(true)
                
                let blockAlert = UIAlertController(title: "This User Has Been Blocked", message: nil, preferredStyle: .alert)
                
                let blockDismiss = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                    
                    self.performSegue(withIdentifier: "homeSegue2", sender: nil)
                    
                })
                
                blockAlert.addAction(blockDismiss)
                self.present(blockAlert, animated: true, completion: nil)
                
            })
            
            let reportAction = UIAlertAction(title: "Report Event", style: .destructive, handler: { action in
                
                let reportAlert = UIAlertController(title: "Report Event", message: "What's Wrong With This Event?", preferredStyle: .alert)
                
                let rAction1 = UIAlertAction(title: "Offensive/Inappropriate Language", style: .default, handler: { action in
                    
                    self.dataBaseRef.child("Reported Events").child(self.eventKey).setValue("Offensive/Inappropriate Language")
                    
                    self.present(thankAlert, animated: true, completion: nil)
                    
                })
                
                let rAction2 = UIAlertAction(title: "Unsafe Event", style: .default, handler: { action in
                    
                    self.dataBaseRef.child("Reported Events").child(self.eventKey).setValue("Unsafe Event")
                    
                    self.present(thankAlert, animated: true, completion: nil)
                    
                })
                
                let rAction3 = UIAlertAction(title: "Other", style: .default, handler: { action in
                    
                    self.dataBaseRef.child("Reported Events").child(self.eventKey).setValue("Other")
                    
                    self.present(thankAlert, animated: true, completion: nil)
                    
                })
                
                reportAlert.addAction(rAction1)
                reportAlert.addAction(rAction2)
                reportAlert.addAction(rAction3)
                reportAlert.addAction(dismissAction)
                self.present(reportAlert, animated: true, completion: nil)
                
            })
            
            alert.addAction(blockAction)
            alert.addAction(reportAction)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if(self.eUid == "KFDuKYEoHbUmc1B0nsfbssON6zY2" || self.eUid == "5EeE4RHUxWTa0E8BmwK2b0V1kKn2" || self.eUid == "3kMQYwkjlUOmZU651KbrblkMYWp2"){
            
            let alert = UIAlertController(title: "Event Options", message: "Report the Event for Offensive Content or Block Whomever Created It?", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Back", style: .cancel, handler: nil)
            
            let thankDismiss = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                
                self.performSegue(withIdentifier: "homeSegue2", sender: nil)
                
            })
            
            let thankAlert = UIAlertController(title: "Report Submitted", message: "Thank You for Submitting Your Report. We Apologize for the Content of This Event. We'll Fix Any Issues With It As Soon As Possible.", preferredStyle: .alert)
            
            thankAlert.addAction(thankDismiss)
            
            
            let blockAction = UIAlertAction(title: "Block User", style: .default, handler: { action in
                
                
                let blockAlert = UIAlertController(title: "Sorry, But You Cannot Block Administrative Accounts", message: nil, preferredStyle: .alert)
                
                let blockDismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                
                blockAlert.addAction(blockDismiss)
                self.present(blockAlert, animated: true, completion: nil)
                
            })
            
            let reportAction = UIAlertAction(title: "Report Event", style: .destructive, handler: { action in
                
                let reportAlert = UIAlertController(title: "Report Event", message: "What's Wrong With This Event?", preferredStyle: .alert)
                
                let rAction1 = UIAlertAction(title: "Offensive/Inappropriate Language", style: .default, handler: { action in
                    
                    self.dataBaseRef.child("Reported Events").child(self.eventKey).setValue("Offensive/Inappropriate Language")
                    
                    self.present(thankAlert, animated: true, completion: nil)
                    
                })
                
                let rAction2 = UIAlertAction(title: "Unsafe Event", style: .default, handler: { action in
                    
                    self.dataBaseRef.child("Reported Events").child(self.eventKey).setValue("Unsafe Event")
                    
                    self.present(thankAlert, animated: true, completion: nil)
                    
                })
                
                let rAction3 = UIAlertAction(title: "Other", style: .default, handler: { action in
                    
                    self.dataBaseRef.child("Reported Events").child(self.eventKey).setValue("Other")
                    
                    self.present(thankAlert, animated: true, completion: nil)
                    
                })
                
                reportAlert.addAction(rAction1)
                reportAlert.addAction(rAction2)
                reportAlert.addAction(rAction3)
                reportAlert.addAction(dismissAction)
                self.present(reportAlert, animated: true, completion: nil)
                
            })
            
            alert.addAction(blockAction)
            alert.addAction(reportAction)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }

    

    @IBAction func didTapBack(_ sender: Any) {
        performSegue(withIdentifier: "homeSegue2", sender: nil)
    }


    @IBAction func didPressEdit(_ sender: Any) {
        performSegue(withIdentifier: "editEventSegue", sender: editKey)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editEventSegue"){
            let editEvent = segue.destination as! NewEventViewController
            editEvent.editKey = sender as! String
            editEvent.editingEvent = true
            editEvent.eventPaid = eventPaid
        }
    }


    @IBAction func didPressDelete(_ sender: Any) {
        self.dataBaseRef.child("Event").child(eventKey).removeValue()
        performSegue(withIdentifier: "homeSegue2", sender: nil)
    }
    

    
    
    func didTapEventPhoto(sender: UITapGestureRecognizer){
        
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        
        newImageView.frame = self.view.frame
        
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage))
        
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        
    }
    
    func dismissFullScreenImage(sender: UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
        
    }
    @IBAction func didPressMapButton(_ sender: Any) {
        
        convertAddressToLatAndLong()
        
        self.eventDescription.text = self.evDescription + "\nAddress: " + self.eAddress

        
    }

    @IBAction func didPressCalendarButton(_ sender: Any) {
        
        let eventStore = EKEventStore()
        self.formatter.dateFormat = "dd/MM/yyyy"
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) && (self.formatter.date(from: self.eDate) != nil){
                let event = EKEvent(eventStore: eventStore)
                event.title = self.evTitle
                event.location = self.eAddress
                event.startDate = self.formatter.date(from: self.eDate)!
                event.endDate = self.formatter.date(from: self.eDate)!
                event.isAllDay = true
                let alarm:EKAlarm = EKAlarm(relativeOffset: 3600)
                event.alarms = [alarm]
                
                event.notes = "Event Time: " + self.eTime +
                "/n Location: " + self.eAddress
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                let alert = UIAlertController(title: "Event Saved", message: "The event, " + self.evTitle + ", has been saved", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Saved Event")
            }
            else{
                let alert = UIAlertController(title: "Event Couldn't Be Saved", message: "Please check the description for dates", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("failed to save event with error : \(error) or access not granted")
            }
            
        })
        self.eventDescription.text = self.evDescription + "\nDate: " + self.eDate + " | " + self.eTime
    }
    
    func convertAddressToLatAndLong(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.eAddress) {
            
            placemarks, error in
            let placemark = placemarks?.first
            self.lat = placemark?.location?.coordinate.latitude
            self.lon = placemark?.location?.coordinate.longitude
            
            let coordinate = CLLocationCoordinate2DMake(self.lat!, self.lon!)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = self.evTitle
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            
        }
        

        
    }
    

    func platformType(platform : NSString){
        if platform.isEqual(to: "iPhone1,1")  {
        }

        else if platform.isEqual(to: "iPhone5,4"){
        }
        else if platform.isEqual(to: "iPhone6,1"){
        }
        else if platform.isEqual(to: "iPhone6,2"){
        }
        else if platform.isEqual(to: "iPhone7,2"){
        }
        else if platform.isEqual(to: "iPhone7,1"){
        }
        else if platform.isEqual(to: "iPhone8,1"){
        }
        else if platform.isEqual(to: "iPhone8,2"){
        }
        else if platform.isEqual(to: "iPhone8,4"){
        }
        else if platform.isEqual(to: "iPhone9,1"){
        }
        else if platform.isEqual(to: "iPhone9,2"){
        }
        else if platform.isEqual(to: "iPhone9,3"){
        }
        else if platform.isEqual(to: "iPhone9,4"){
        }

        else if platform.isEqual(to: "iPad2,7"){
        }
        else if platform.isEqual(to: "iPad3,1"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad3,2"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad3,3"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad3,4"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad3,5"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad3,6"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,1"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,2"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,3"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,4"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,5"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,6"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,7"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,8"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad4,9"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad5,3"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "iPad5,4"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }

        else if platform.isEqual(to: "i386"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
        else if platform.isEqual(to: "x86_64"){
            self.mapButton.isHidden = true
            self.calendarButton.isHidden = true
        }
    }

}
