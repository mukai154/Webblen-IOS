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
import NVActivityIndicatorView
import SDWebImage

class EventInfoViewController: UIViewController {

    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventUploadedPhoto: UIImageView!
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    @IBOutlet weak var eventAddress: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    
    @IBOutlet weak var imageBottomShadow: UIViewX!
    
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
    var eventCategories : [String] = []
    var currentDate = Date()
    var formatter = DateFormatter()
    var eventAuthor : String?
    
    var currentUser:  AnyObject?
    var username: String?
    var dataBaseRef: DatabaseReference!
    var dataBase = Firestore.firestore()
    var madeEvent = false

    var lat : Double?
    var lon : Double?
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .orbit, color: UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 0.9), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.alpha = 0
        eventUploadedPhoto.isHidden = true
        
        //Activity indicator starts
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-60), y: (yAxis-45), width: 125, height: 125)
        loadingView = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        
        
        eventDescription.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0)
        eventDescription.textColor = UIColor.lightGray
        let initialDescriptionHeight = eventDescription.contentSize.height
        let initialContentHeight = scrollView.frame.size.height



        
        dataBaseRef = Database.database().reference()
        self.currentUser = Auth.auth().currentUser
        self.editKey = self.eventKey
        
            
            let eventRef = self.dataBase.collection("events").document(self.eventKey)
            eventRef.getDocument(completion: {(event, error) in
                if let event = event {
                    self.eventCategories = event.data()!["categories"] as! [String]
                    self.eventImage.image = UIImage(named: self.eventCategories.first!)
                    self.eventTitle.text = event.data()!["title"] as! String
                    self.evTitle = event.data()!["title"] as! String
                    self.eventDescription.text = event.data()!["description"] as! String
                    self.lat = event.data()!["lat"] as! Double
                    self.lon = event.data()!["lon"] as! Double

                    self.eventAuthor = event.data()!["author"] as! String
                    let imageURL = event.data()!["pathToImage"] as! String
                    print(imageURL)
                    if imageURL != "" {
                        let url = NSURL(string: imageURL)
                        self.eventUploadedPhoto.sd_setImage(with: url! as URL)
                        self.eventUploadedPhoto.isHidden = false
                        self.eventDescription.translatesAutoresizingMaskIntoConstraints = true
                        self.eventDescription.sizeToFit()

                    }
                    else {
                        self.imageViewHeightConstraint.constant = 0
                        self.imageBottomShadow.isHidden = true
                        self.scrollView.isScrollEnabled = false
                    }
                    self.eventCreator.text = "@" + self.eventAuthor!
                    self.eventAddress.text = event.data()!["address"] as! String
                    let eDate = event.data()!["date"] as! String
                    let eTime = event.data()!["time"] as! String
                    self.eventDate.text = eDate + " | " + eTime
                    let views = event.data()!["views"] as! Int
                    let newViewCount = views + 1
                    self.eventViews.text = String(views) + " Views"
                    self.scrollView.isHidden = false
                    eventRef.updateData([
                        "views": newViewCount
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            let checkUsernameRef = self.dataBase.collection("users").document((self.currentUser?.uid)!)
                            checkUsernameRef.getDocument(completion: {(userDoc, error) in
                                if let userDoc = userDoc {
                                    self.username = userDoc.data()!["username"] as! String
                                    if (self.username == self.eventAuthor) || (self.username == "Webblen") {
                                      self.madeEvent == true
                                    }
                                }
                                else {
                                   print("Did not create event")
                                }
                            })
                        }
                    }
                    UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                        self.scrollView.alpha = 1.0 // Here you will get the animation you want
                    }, completion: nil)
                    self.loadingView.stopAnimating()
                }
                else {
                    print("doc does not exist")
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
        if (madeEvent == true || (self.username == eventAuthor) || (self.username == "Webblen")){
            
            let alert = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
            let editEvent = UIAlertAction(title: "Edit Event", style: .default, handler: { action in
                self.performSegue(withIdentifier: "editEventSegue", sender: self.eventKey)
            })
            let deleteEvent = UIAlertAction(title: "Delete Event", style: .destructive, handler: { action in
                self.dataBase.collection("events").document(self.eventKey).delete()
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
            })
            let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(editEvent)
            alert.addAction(deleteEvent)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else if (madeEvent == false && (self.username == self.eventAuthor) || (self.username == "Webblen")){
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let thankDismiss = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
            })
            
            let thankAlert = UIAlertController(title: "Report Submitted", message: "Thank You for Submitting Your Report. We'll Address This Issue As Soon As Possible. Block the User to No Longer View Events By Them", preferredStyle: .alert)
            
            thankAlert.addAction(thankDismiss)
            
            
            let blockAction = UIAlertAction(title: "Block User", style: .default, handler: { action in
                let userDocRef = self.dataBase.collection("users").document((self.currentUser?.uid)!)
                userDocRef.getDocument(completion: {(userDoc, error) in
                    if let userDoc = userDoc {
                        var blockedUsers = userDoc.data()!["blockedUsers"] as! [String]
                        blockedUsers.append(self.eventAuthor!)
                        userDocRef.updateData([
                            "blockedUsers": blockedUsers
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                    else {
                      print("Error")
                    }
                })
                
                let blockAlert = UIAlertController(title: "This User Has Been Blocked", message: nil, preferredStyle: .alert)
                
                let blockDismiss = UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
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
        dismiss(animated: true, completion: nil)
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
        
        
            let coordinate = CLLocationCoordinate2DMake(self.lat!, self.lon!)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = self.evTitle
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
    

  
}
