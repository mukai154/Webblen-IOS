//
//  EventInfoViewController.swift
//  Webblen
//
//  Created by Mukai Selekwa on 1/17/17.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
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
    
  
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    
    
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
    var imageStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/events")
    var madeEvent = false
    var userPicsDictionary = [String: String]()

    var lat : Double?
    var lon : Double?
    
    //Extras
    var activeColor = UIColor(red: 30/300, green: 39/300, blue: 46/300, alpha: 1.0)
    var inactiveColor = UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0)
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .orbit, color: UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 0.9), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //***UI Elements
        scrollView.alpha = 0
        eventUploadedPhoto.isHidden = true
        
        //Activity indicator
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
        loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: activeColor, padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        let initialDescriptionHeight = eventDescription.contentSize.height
        let initialContentHeight = scrollView.frame.size.height
        let initialContentWidth = scrollView.frame.size.width



        //Retrieve Event From Firebase Firestore
        dataBaseRef = Database.database().reference()
        self.currentUser = Auth.auth().currentUser
        self.editKey = self.eventKey
        
            let eventRef = self.dataBase.collection("events").document(self.eventKey)
            eventRef.getDocument(completion: {(event, error) in
                if let event = event {
                    self.eventCategories = event.data()!["categories"] as! [String]
                    self.eventTitle.text = event.data()!["title"] as! String
                    self.evTitle = event.data()!["title"] as! String
                    self.evDescription = event.data()!["description"] as! String
                    self.eventDescription.text = event.data()!["description"] as! String
                    self.lat = event.data()!["lat"] as! Double
                    self.lon = event.data()!["lon"] as! Double
                    
                    //**User Author Pic
                    self.eventAuthor = event.data()!["author"] as! String
                    if self.userPicsDictionary[self.eventAuthor!] == nil {
                        self.dataBase.collection("usernames").document((self.eventAuthor?.lowercased())!).getDocument { (document, error) in
                            if let document = document, document.exists {
                                let author_uid = document.data()!["uid"] as! String
                                self.dataBase.collection("users").document(author_uid).getDocument{ (userDoc, error) in
                                    if let userDoc = userDoc, userDoc.exists {
                                        self.userPicsDictionary[self.eventAuthor!] = userDoc.data()!["profile_pic"] as? String
                                        let userPicPath = self.userPicsDictionary[self.eventAuthor!]
                                        let userPicUrl = NSURL(string: userPicPath!)
                                        self.eventImage.sd_setImage(with: userPicUrl! as URL, placeholderImage: nil)
                                    }
                                }
                            } else {
                                self.eventImage.image = UIImage(named: self.eventCategories.first!)
                            }
                            
                            self.eventImage.layer.cornerRadius = self.eventImage.frame.size.width / 2;
                            self.eventImage.clipsToBounds = true;
                        }
                    }
                    
                    //**Event Img
                    let imageURL = event.data()!["pathToImage"] as! String
                    print(imageURL)
                    if imageURL != "" {
                        let url = NSURL(string: imageURL)
                        self.eventUploadedPhoto.sd_setImage(with: url! as URL, placeholderImage: nil)
                        self.eventUploadedPhoto.clipsToBounds = true;
                        self.eventUploadedPhoto.isHidden = false
                    }
                    else {
                        self.imageViewHeightConstraint.constant = 0
                    }
                    
                    self.eventDescription.translatesAutoresizingMaskIntoConstraints = true
                    self.eventDescription.sizeToFit()
                    self.eventDescription.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
                    self.eventCreator.text = "@" + self.eventAuthor!
                    self.eventAddress.text = event.data()!["address"] as! String
                    let eDate = event.data()!["date"] as! String
                    let eTime = event.data()!["time"] as! String
                    self.eventDate.text = eDate + " | " + eTime
                    let views = event.data()!["views"] as! Int
                    let newViewCount = views + 1
                    self.eventViews.text = String(views)
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
                                    if (self.username == self.eventAuthor) || (self.username?.lowercased() == "webblen") {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func didTabBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Options Available for Event
    @IBAction func didTapOptionDots(_ sender: Any) {
        if (madeEvent == true || (self.username == eventAuthor) || (self.username?.lowercased() == "webblen")){
            
            let alert = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
            let editEvent = UIAlertAction(title: "Edit Event", style: .default, handler: { action in
                self.performSegue(withIdentifier: "editEventSegue", sender: self.eventKey)
            })
            let deleteEvent = UIAlertAction(title: "Delete Event", style: .destructive, handler: { action in
                let imagePath = self.eventKey + ".jpg"
                self.imageStorage.child(imagePath).delete { error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        // File deleted successfully
                    }
                }
                self.dataBase.collection("events").document(self.eventKey).delete()
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
            })
            let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(editEvent)
            alert.addAction(deleteEvent)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if (madeEvent == false && (self.username == self.eventAuthor) || (self.username?.lowercased() == "webblen")){
            
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
    
    //Prepare Segue for Editing Event
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
        setupMaps()
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
                let alert = UIAlertController(title: "Event Saved", message: "This Event Has Been Saved in Your Calendar", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Saved Event")
            }
            else{
                let alert = UIAlertController(title: "Event Couldn't Be Saved", message: "This Event Cannot Be Saved to Your Calendar", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("failed to save event with error : \(error) or access not granted")
            }
            
        })
    }
    
    func setupMaps(){
            let coordinate = CLLocationCoordinate2DMake(self.lat!, self.lon!)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = self.evTitle
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func didPressMessageBoard(_ sender: Any) {
        showAlert(withTitle: "Messages Board Unavailable", message: "Sorry, this feature is currently unavailable")
    }
    
      
}
