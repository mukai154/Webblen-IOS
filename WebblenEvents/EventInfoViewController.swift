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
    @IBOutlet weak var eventViews: UILabel!
    @IBOutlet weak var eventDescription: UITextView!

  
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var calendarIcon: UIImageView!
    
    @IBOutlet weak var centerLineBreak: UIView!
    @IBOutlet weak var eventOptions: UIBarButtonItem!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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
    var dataBaseRef: DatabaseReference!
    var madeEvent = false

    var lat : Double?
    var lon : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        eventUploadedPhoto.isHidden = true
        
        
        
        eventDescription.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0)
        eventDescription.textColor = UIColor.lightGray


        
        dataBaseRef = Database.database().reference()
        self.currentUser = Auth.auth().currentUser
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
                //self.eventUploadedPhoto.sd_setImage(with: url! as URL)
                self.activityIndicator.stopAnimating()
                self.eventUploadedPhoto.isHidden = false
                }
                else {
                self.eventUploadedPhoto.isHidden = true
                self.imageViewHeightConstraint.constant = 0
                self.activityIndicator.stopAnimating()
                }
                self.eUid = eDict["uid"] as! String
                let eUsername = eDict["username"] as! String
                if (self.eUid == self.currentUser?.uid || self.currentUser?.uid == "KFDuKYEoHbUmc1B0nsfbssON6zY2" ){
                    self.madeEvent = true
                    }
                if (self.ePayment == "true"){
                    self.eventPaid = true
                }
                
            }
        
        })
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
        
        eventUploadedPhoto.isUserInteractionEnabled = true
        
        eventUploadedPhoto.addGestureRecognizer(imageTap)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressEventOptions(_ sender: Any) {
        if (madeEvent == true || self.eUid == "KFDuKYEoHbUmc1B0nsfbssON6zY2" || self.eUid == "5EeE4RHUxWTa0E8BmwK2b0V1kKn2" || self.eUid == "3kMQYwkjlUOmZU651KbrblkMYWp2"){
            
            let alert = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
            let editEvent = UIAlertAction(title: "Edit Event", style: .default, handler: { action in
                self.performSegue(withIdentifier: "editEventSegue", sender: self.editKey)
            })
            let deleteEvent = UIAlertAction(title: "Delete Event", style: .destructive, handler: { action in
                self.dataBaseRef.child("Event").child(self.eventKey).removeValue()
                self.performSegue(withIdentifier: "homeSegue2", sender: nil)
            })
            let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(editEvent)
            alert.addAction(deleteEvent)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else if (madeEvent == false && self.eUid != "KFDuKYEoHbUmc1B0nsfbssON6zY2" || self.eUid != "5EeE4RHUxWTa0E8BmwK2b0V1kKn2" || self.eUid != "3kMQYwkjlUOmZU651KbrblkMYWp2"){
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
        
    }

    

    @IBAction func didTapBack(_ sender: Any) {
        performSegue(withIdentifier: "homeSegue2", sender: nil)
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editEventSegue"){
            let editEvent = segue.destination as! NewEventViewController
            editEvent.eventKey = sender as! String
            editEvent.editingEvent = true
            editEvent.eventPaid = eventPaid
        }
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
    

  
}
