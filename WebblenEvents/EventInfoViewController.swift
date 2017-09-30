//
//  EventInfoViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/17/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase

class EventInfoViewController: UIViewController {

    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventUploadedPhoto: UIImageView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventCreator: UILabel!
    @IBOutlet weak var eventDescription: UITextView!

    @IBOutlet weak var eventAddress: UITextView!
  

    @IBOutlet weak var eventDate: UITextView!
    
    
    @IBOutlet weak var editEventButton: UIButton!
    @IBOutlet weak var deleteEventButton: UIButton!
    
    @IBOutlet weak var reportButton: UIBarButtonItem!

    @IBOutlet weak var imageHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    
    var imageName = "AMUSEMENT"
    var eTitle = "Title"
    var date = "January 17, 2017"
    var time = "10:00PM"
    var dateTime = "String"
    var creator = "Admin"
    var evDescription = "description"
    var evTitle = "uid"
    var eventKey = "key"
    var eUid = "String"
    
    var currentUser:  AnyObject?
    var dataBaseRef: FIRDatabaseReference!
    var madeEvent = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize : CGRect = UIScreen.main.bounds
        imageHeightConstrain.constant = screenSize.height * 0.20
        descriptionHeightConstraint.constant = screenSize.height * 0.20
        
        
        eventUploadedPhoto.layer.cornerRadius = 5
        eventUploadedPhoto.layer.masksToBounds = true
        
        eventDescription.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0)
        eventDescription.textColor = UIColor.lightGray
        eventAddress.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //self.editEventButton.layer.cornerRadius = CGFloat(5.0)
        //self.deleteEventButton.layer.cornerRadius = CGFloat(5.0)

        
        self.editEventButton.isHidden = true
        self.editEventButton.isEnabled = false
        self.deleteEventButton.isHidden = true
        self.deleteEventButton.isEnabled = false

        
        dataBaseRef = FIRDatabase.database().reference()
        self.currentUser = FIRAuth.auth()?.currentUser
        
        self.dataBaseRef.child("Event").child(eventKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let eDict = snapshot.value as? [String: AnyObject]{
                self.eventImage.image = UIImage(named: (eDict["category"] as? String)!)
                self.eventTitle.text = eDict["title"] as? String
                self.eventCreator.text = eDict["username"] as? String
                self.eventDescription.text = eDict["evDescription"] as! String
                let eDate = eDict["date"] as! String
                let eTime = eDict["time"] as! String
                let eCat = eDict["category"] as! String
                let eAddress = eDict["address"] as! String
                let ePhoto = eDict["pathToImage"] as! String
                
                if (ePhoto != "null"){
                let url = NSURL(string: ePhoto)
                self.eventUploadedPhoto.sd_setImage(with: url! as URL)
                }
                else {
                self.eventUploadedPhoto.isHidden = true
                self.imageViewHeightConstraint.constant = 0
                }
                self.eventAddress.text = eAddress
                self.eventDate.text = eDate + " | " + eTime
                self.eUid = eDict["uid"] as! String
                let eUsername = eDict["username"] as! String
                if (self.eUid == self.currentUser?.uid || self.currentUser?.uid == "KFDuKYEoHbUmc1B0nsfbssON6zY2" ){
                    if(eCat != "WARNING"){
                    //self.editEventButton.isHidden = false
                    //self.editEventButton.isEnabled = true
                    }
                    self.deleteEventButton.isHidden = false
                    self.deleteEventButton.isEnabled = true
                    self.madeEvent = true
                }
                
            }
        
        })
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
        
        eventUploadedPhoto.isUserInteractionEnabled = true
        
        eventUploadedPhoto.addGestureRecognizer(imageTap)
        
        // Do any additional setup after loading the view.
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
        
        if(self.eUid == "KFDuKYEoHbUmc1B0nsfbssON6zY2"){
            
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
        performSegue(withIdentifier: "editEventSegue", sender: eventKey)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editEventSegue"){
            let editEvent = segue.destination as! NewEventViewController
            editEvent.eventKey = sender as! String
        }
    }


    @IBAction func didPressDelete(_ sender: Any) {
        self.dataBaseRef.child("Event").child(eventKey).removeValue()
        performSegue(withIdentifier: "homeSegue2", sender: nil)
    }
    

    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editEventSegue"){
            let eventEd = segue.destination as! EditEventViewController
            eventEd.eventKey = sender as? String
        }
    } */
    
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

}
