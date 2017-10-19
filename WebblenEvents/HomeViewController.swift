//
//  HomeViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 1/5/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import CoreLocation




class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    var currentUser:  AnyObject?
    var currentUserData: FIRDatabaseReference!
    var currentBlock: FIRDatabaseReference!
    var modifiedDescription : String?
    
    var userInterests = ["none"]
    var userBlocks = ["key"]
    var interestHandle: FIRDatabaseHandle?
    var numberOfEvents = 0
    
    var defaultImageViewHeightConstraint:CGFloat = 225
    var locationManager = CLLocationManager()

    
    
    


    @IBOutlet weak var trailingMenuConstraint: NSLayoutConstraint!
    var menuShowing = false

    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var navBack: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var todayOption: UIButton!
    @IBOutlet weak var thisWeekOption: UIButton!
    @IBOutlet weak var thisMonthOption: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var noEventText: UITextView!
    
    
    var dataBaseRef: FIRDatabaseReference!
    
    //Event Date Organzation
    var events = [Event]()
    var eventsToday = [Event]()
    var eventsThisWeek = [Event]()
    var eventsThisMonth = [Event]()
    
    var today = true
    var thisWeek = false
    var thisMonth = false
    
    var currentDate = Date()
    var formatter = DateFormatter()
    
    var tableCount = 0
    




    fileprivate var _refHandle: FIRDatabaseHandle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        noEventText.isHidden = true
        homeTableView.isHidden = true
        formatter.dateFormat = "MM/dd/yyyy"
        
        //Menu Layout
        menu.layer.shadowOpacity = 0.5
        menu.layer.shadowOffset = CGSize(width: 0, height: 3)
        todayOption.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        thisWeekOption.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        //Update Location
        updateLocation()
        
        //Activity Indicator
        
        
        
        //Database Reference
        dataBaseRef = FIRDatabase.database().reference()

        //User Reference
        self.currentUser = FIRAuth.auth()?.currentUser
        currentUserData = dataBaseRef.child("Users").child(self.currentUser!.uid).child("interests")
        currentBlock = dataBaseRef.child("Users").child(self.currentUser!.uid).child("Blocked Users")
        
        //Grab the user's interests
        self.currentUserData?.observe(.value, with: { (snapshot) in
            
            if let interestDictionary = snapshot.value as? [String: AnyObject]{
                let amusement = interestDictionary["AMUSEMENT"] as? Bool
                    if (amusement == true){
                        if(self.userInterests.contains("AMUSEMENT") == false){
                            self.userInterests.append("AMUSEMENT")
                        }
                    }
                    if(amusement == false){
                        if(self.userInterests.contains("AMUSEMENT")){
                            let interestIndex = self.userInterests.index(of: "AMUSEMENT")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                

                let art = interestDictionary["ART"] as? Bool
                    if (art == true){
                        if(self.userInterests.contains("ART") == false){
                            self.userInterests.append("ART")
                        }
                    }
                    if(art == false){
                        if(self.userInterests.contains("ART")){
                            let interestIndex = self.userInterests.index(of: "ART")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                
                
                let community = interestDictionary["COMMUNITY"] as? Bool
                    if (community == true){
                        if(self.userInterests.contains("COMMUNITY") == false){
                            self.userInterests.append("COMMUNITY")
                        }
                    }
                    if(community == false){
                        if(self.userInterests.contains("COMMUNITY")){
                            let interestIndex = self.userInterests.index(of: "COMMUNITY")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                
                
                let competition = interestDictionary["COMPETITION"] as? Bool
                    if (competition == true){
                        if(self.userInterests.contains("COMPETITION") == false){
                            self.userInterests.append("COMPETITION")
                        }
                    }
                    if(competition == false){
                        if(self.userInterests.contains("COMPETITION")){
                            let interestIndex = self.userInterests.index(of: "COMPETITION")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let culture = interestDictionary["CULTURE"] as? Bool
                    if (culture == true){
                        if(self.userInterests.contains("CULTURE") == false){
                            self.userInterests.append("CULTURE")
                        }
                    }
                    if(culture == false){
                        if(self.userInterests.contains("CULTURE")){
                            let interestIndex = self.userInterests.index(of: "CULTURE")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let education = interestDictionary["EDUCATION"] as? Bool
                    if (education == true){
                        if(self.userInterests.contains("EDUCATION") == false){
                            self.userInterests.append("EDUCATION")
                        }
                    }
                    if(education == false){
                        if(self.userInterests.contains("EDUCATION")){
                            let interestIndex = self.userInterests.index(of: "EDUCATION")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                
                
                let entertainment = interestDictionary["ENTERTAINMENT"] as? Bool
                    if (entertainment == true){
                        if(self.userInterests.contains("ENTERTAINMENT") == false){
                            self.userInterests.append("ENTERTAINMENT")
                        }
                    }
                    if(entertainment == false){
                        if(self.userInterests.contains("ENTERTAINMENT")){
                            let interestIndex = self.userInterests.index(of: "ENTERTAINMENT")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                
                
                let family = interestDictionary["FAMILY"] as? Bool
                    if (family == true){
                        if(self.userInterests.contains("FAMILY") == false){
                            self.userInterests.append("FAMILY")
                        }
                    }
                    if(family == false){
                        if(self.userInterests.contains("FAMILY")){
                            let interestIndex = self.userInterests.index(of: "FAMILY")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                
                
                let foodDrink = interestDictionary["FOODDRINK"] as? Bool
                    if (foodDrink == true){
                        if(self.userInterests.contains("FOODDRINK") == false){
                            self.userInterests.append("FOODDRINK")
                        }
                    }
                    if(foodDrink == false){
                        if(self.userInterests.contains("FOODDRINK")){
                            let interestIndex = self.userInterests.index(of: "FOODDRINK")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let gaming = interestDictionary["GAMING"] as? Bool
                    if (gaming == true){
                        if(self.userInterests.contains("GAMING") == false){
                            self.userInterests.append("GAMING")
                        }
                    }
                    if(gaming == false){
                        if(self.userInterests.contains("GAMING")){
                            let interestIndex = self.userInterests.index(of: "GAMING")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let healthFitness = interestDictionary["HEALTHFITNESS"] as? Bool
                    if (healthFitness == true){
                        if(self.userInterests.contains("HEALTHFITNESS") == false){
                            self.userInterests.append("HEALTHFITNESS")
                        }
                    }
                    if(healthFitness == false){
                        if(self.userInterests.contains("HEALTHFITNESS")){
                            let interestIndex = self.userInterests.index(of: "HEALTHFITNESS")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let music = interestDictionary["MUSIC"] as? Bool
                    if (music == true){
                        if(self.userInterests.contains("MUSIC") == false){
                            self.userInterests.append("MUSIC")
                        }
                    }
                    if(music == false){
                        if(self.userInterests.contains("MUSIC")){
                            let interestIndex = self.userInterests.index(of: "MUSIC")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let networking = interestDictionary["NETWORKING"] as? Bool
                    if (networking == true){
                        if(self.userInterests.contains("NETWORKING") == false){
                            self.userInterests.append("NETWORKING")
                        }
                    }
                    if(networking == false){
                        if(self.userInterests.contains("NETWORKING")){
                            let interestIndex = self.userInterests.index(of: "NETWORKING")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                let outdoors = interestDictionary["OUTDOORS"] as? Bool
                    if (outdoors == true){
                        if(self.userInterests.contains("OUTDOORS") == false){
                            self.userInterests.append("OUTDOORS")
                        }
                    }
                    if(outdoors == false){
                        if(self.userInterests.contains("OUTDOORS")){
                            let interestIndex = self.userInterests.index(of: "OUTDOORS")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                let shopping = interestDictionary["SHOPPING"] as? Bool
                    if (shopping == true){
                        if(self.userInterests.contains("SHOPPING") == false){
                            self.userInterests.append("SHOPPING")
                        }
                    }
                    if(shopping == false){
                        if(self.userInterests.contains("SHOPPING")){
                            let interestIndex = self.userInterests.index(of: "SHOPPING")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let sports = interestDictionary["SPORTS"] as? Bool
                    if (sports == true){
                        if(self.userInterests.contains("SPORTS") == false){
                            self.userInterests.append("SPORTS")
                        }
                    }
                    if(sports == false){
                        if(self.userInterests.contains("SPORTS")){
                            let interestIndex = self.userInterests.index(of: "SPORTS")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let technology = interestDictionary["TECHNOLOGY"] as? Bool
                    if (technology == true){
                        if(self.userInterests.contains("TECHNOLOGY") == false){
                            self.userInterests.append("TECHNOLOGY")
                        }
                    }
                    if(technology == false){
                        if(self.userInterests.contains("TECHNOLOGY")){
                            let interestIndex = self.userInterests.index(of: "TECHNOLOGY")
                            self.userInterests.remove(at: interestIndex!)
                        }
                }
                    
                
                let theatre = interestDictionary["THEATRE"] as? Bool
                    if (theatre == true){
                        if(self.userInterests.contains("THEATRE") == false){
                            self.userInterests.append("THEATRE")
                            
                        }
                    }
                    if(theatre == false){
                        if(self.userInterests.contains("THEATRE")){
                            let interestIndex = self.userInterests.index(of: "THEATRE")
                            self.userInterests.remove(at: interestIndex!)
                        }
                    }
                let collegeLife = interestDictionary["COLLEGELIFE"] as? Bool
                    if (collegeLife == true){
                        if(self.userInterests.contains("COLLEGELIFE") == false){
                            self.userInterests.append("COLLEGELIFE")
                        
                    }
                }
                    if(collegeLife == false){
                        if(self.userInterests.contains("COLLEGELIFE")){
                            let interestIndex = self.userInterests.index(of: "COLLEGELIFE")
                            self.userInterests.remove(at: interestIndex!)
                    }
                }
                let wineBrew = interestDictionary["WINEBREW"] as? Bool
                if (wineBrew == true){
                    if(self.userInterests.contains("WINEBREW") == false){
                        self.userInterests.append("WINEBREW")
                        
                    }
                }
                if(wineBrew == false){
                    if(self.userInterests.contains("WINEBREW")){
                        let interestIndex = self.userInterests.index(of: "WINEBREW")
                        self.userInterests.remove(at: interestIndex!)
                    }
                }
                let partyDance = interestDictionary["PARTYDANCE"] as? Bool
                if (partyDance == true){
                    if(self.userInterests.contains("PARTYDANCE") == false){
                        self.userInterests.append("PARTYDANCE")
                        
                    }
                }
                if(partyDance == false){
                    if(self.userInterests.contains("PARTYDANCE")){
                        let interestIndex = self.userInterests.index(of: "PARTYDANCE")
                        self.userInterests.remove(at: interestIndex!)
                    }
                }
                
                }
            
            print(self.userInterests)
            
            //Gather blocked users
            self.currentBlock.queryOrderedByValue().queryEqual(toValue: true).observeSingleEvent(of: .value, with: { (snap) in
                if let snapDict = snap.value as? [String:AnyObject]{
                    for each in snapDict{
                        self.userBlocks.append(each.key)
                        print(self.userBlocks)
                    }
                }
            })
            self.configureDatabase()
        })
        
        self.currentUser = FIRAuth.auth()?.currentUser
        
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.estimatedRowHeight = 250
        
    }


    
    func configureDatabase(){
        
        
        
        //Organize event posts data
        self.dataBaseRef.child("Event").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snap) in
        
            //Check if category of the event fulfills the user's interests
            let eventSnap = snap.value as! [String: AnyObject]
            for (_,event) in eventSnap {
                if let eventCategory = event["category"] as? String {
                    for each in self.userInterests {
                        if (each == eventCategory ){
                            if let eKey = event["uid"] as? String {
                                if(event["paid"] as! String == "true"){
                                    
                        //Event data
                        let eventPost = Event()
                        if let category = event["category"] as? String, let date = event["date"] as? String, let evDescription = event["evDescription"] as? String, let time = event["time"] as? String, let title = event["title"] as? String, let uid = event["uid"] as? String, let username = event["username"] as? String, let pathToImage = event["pathToImage"] as? String, let verified = event["verified"] as? String, let eventKey = event["eventKey"] as? String, let paid = event["paid"] as? String, let radius = event["radius"] as? String{
                            eventPost.category = category
                            eventPost.paid = paid
                            eventPost.date = date
                            eventPost.evDescription = evDescription
                            self.modifiedDescription = evDescription
                            eventPost.title = title
                            eventPost.time = time
                            eventPost.uid = uid
                            eventPost.username = username
                            eventPost.eventKey = eventKey
                            eventPost.pathToImage = pathToImage
                            eventPost.verified = verified
                        
                            
                            //Append Events According to Date
                            if(self.formatter.date(from: eventPost.date)!.days(from: self.currentDate) < 0){
                                self.dataBaseRef.child("Event").child(eventPost.eventKey).removeValue()
                            }
                            else if (self.formatter.date(from: eventPost.date)!.days(from: self.currentDate) == 0){
                                eventPost.date = "Today"
                                self.eventsToday.append(eventPost)
                                self.checkEvents()
                            }
                            else if (self.formatter.date(from: eventPost.date)!.days(from: self.currentDate) > 0 && self.formatter.date(from: eventPost.date)!.days(from: self.currentDate) <= 7){
                                self.eventsThisWeek.append(eventPost)
                                self.checkEvents()
                            }
                            else {
                                self.eventsThisMonth.append(eventPost)
                                self.checkEvents()
                            }
                            
                                    }
                                }
                            
                                
                            }
                    }
                }
                    self.homeTableView.reloadData()
                    self.homeTableView.isHidden = false
                }
            }
            
        })
        dataBaseRef.removeAllObservers()

    }
    

    //Table view organization
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (today == true){
            self.tableCount = self.eventsToday.count
        }
        else if (thisWeek == true){
            self.tableCount = self.eventsThisWeek.count
        }
        else if (thisMonth == true){
            self.tableCount = self.eventsThisMonth.count
        }
        else{
            self.tableCount = 0
        }
        
        return self.tableCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //SEPARATE CELLS ACCORDING TO EVENT DATE
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeCell
        
        //----TODAY
        if (today == true){
        
        let photo = self.eventsToday[indexPath.row].pathToImage!
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
        
        cell.eventPhoto.isUserInteractionEnabled = true
        
        cell.eventPhoto.addGestureRecognizer(imageTap)
        
        if (self.eventsToday[indexPath.row].evDescription.characters.count > 100){
            
            let index = self.eventsToday[indexPath.row].evDescription.index(self.eventsToday[indexPath.row].evDescription.startIndex, offsetBy: 100)
            
            
            if ((self.eventsToday[indexPath.row].pathToImage) != "null"){
                
                
                cell.eventPhoto.isHidden = false
                cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                
                
                let url = NSURL(string:photo)
                
                
                cell.configure(eventTitle: self.eventsToday[indexPath.row].title,
                               eventDate: self.eventsToday[indexPath.row].date,
                               isVerified: self.eventsToday[indexPath.row].verified,
                               eventDescription: self.eventsToday[indexPath.row].evDescription.substring(to: index) + "...",
                               eventPhoto: self.eventsToday[indexPath.row].pathToImage)
                cell.eventPhoto.sd_setImage(with: url! as URL)
                cell.interestCategory.image = UIImage(named: self.eventsToday[indexPath.row].category)
                
                
            }
                
            else{
                cell.eventPhoto.isHidden = true
                cell.imageViewHeightConstraint.constant = 0
                cell.interestCategory.image = UIImage(named: self.eventsToday[indexPath.row].category)
                cell.eventTitle.text = self.eventsToday[indexPath.row].title
                cell.eventDate.text = self.eventsToday[indexPath.row].date
                cell.eventDescription.text = self.eventsToday[indexPath.row].evDescription.substring(to: index) + "..."
            }
            
        }
            
        else {
            
            if ((self.eventsToday[indexPath.row].pathToImage) != "null"){
                
                cell.eventPhoto.isHidden = false
                cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                
                
                let url = NSURL(string:photo)
                
                
                
                cell.configure(eventTitle: self.eventsToday[indexPath.row].title,
                               eventDate: self.eventsToday[indexPath.row].date,
                               isVerified: self.eventsToday[indexPath.row].verified,
                               eventDescription: self.eventsToday[indexPath.row].evDescription,
                               eventPhoto: self.eventsToday[indexPath.row].pathToImage)
                cell.eventPhoto.sd_setImage(with: url! as URL)
                cell.interestCategory.image = UIImage(named: self.eventsToday[indexPath.row].category)
                
            }
                
            else{
                cell.eventPhoto.isHidden = true
                cell.imageViewHeightConstraint.constant = 0
                cell.interestCategory.image = UIImage(named: self.eventsToday[indexPath.row].category)
                cell.eventTitle.text = self.eventsToday[indexPath.row].title
                cell.eventDate.text = self.eventsToday[indexPath.row].date
                cell.eventDescription.text = self.eventsToday[indexPath.row].evDescription
            }
            
        }
        }
            
        //------THIS WEEK
        else if (thisWeek == true){
            let photo = self.eventsThisWeek[indexPath.row].pathToImage!
            
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
            
            cell.eventPhoto.isUserInteractionEnabled = true
            
            cell.eventPhoto.addGestureRecognizer(imageTap)
            
            if (self.eventsThisWeek[indexPath.row].evDescription.characters.count > 100){
                
                let index = self.eventsThisWeek[indexPath.row].evDescription.index(self.eventsThisWeek[indexPath.row].evDescription.startIndex, offsetBy: 100)
                
                
                if ((self.eventsThisWeek[indexPath.row].pathToImage) != "null"){
                    
                    
                    cell.eventPhoto.isHidden = false
                    cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                    
                    
                    let url = NSURL(string:photo)
                    
                    
                    cell.configure(eventTitle: self.eventsThisWeek[indexPath.row].title,
                                   eventDate: self.eventsThisWeek[indexPath.row].date,
                                   isVerified: self.eventsThisWeek[indexPath.row].verified,
                                   eventDescription: self.eventsThisWeek[indexPath.row].evDescription.substring(to: index) + "...",
                                   eventPhoto: self.eventsThisWeek[indexPath.row].pathToImage)
                    cell.eventPhoto.sd_setImage(with: url! as URL)
                    cell.interestCategory.image = UIImage(named: self.eventsThisWeek[indexPath.row].category)
                    
                    
                }
                    
                else{
                    cell.eventPhoto.isHidden = true
                    cell.imageViewHeightConstraint.constant = 0
                    cell.interestCategory.image = UIImage(named: self.eventsThisWeek[indexPath.row].category)
                    cell.eventTitle.text = self.eventsThisWeek[indexPath.row].title
                    cell.eventDate.text = self.eventsThisWeek[indexPath.row].date
                    cell.eventDescription.text = self.eventsThisWeek[indexPath.row].evDescription.substring(to: index) + "..."
                }
                
            }
                
            else {
                
                if ((self.eventsThisWeek[indexPath.row].pathToImage) != "null"){
                    
                    cell.eventPhoto.isHidden = false
                    cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                    
                    
                    let url = NSURL(string:photo)
                    
                    
                    
                    cell.configure(eventTitle: self.eventsThisWeek[indexPath.row].title,
                                   eventDate: self.eventsThisWeek[indexPath.row].date,
                                   isVerified: self.eventsThisWeek[indexPath.row].verified,
                                   eventDescription: self.eventsThisWeek[indexPath.row].evDescription,
                                   eventPhoto: self.eventsThisWeek[indexPath.row].pathToImage)
                    cell.eventPhoto.sd_setImage(with: url! as URL)
                    cell.interestCategory.image = UIImage(named: self.eventsThisWeek[indexPath.row].category)
                    
                }
                    
                else{
                    cell.eventPhoto.isHidden = true
                    cell.imageViewHeightConstraint.constant = 0
                    cell.interestCategory.image = UIImage(named: self.eventsThisWeek[indexPath.row].category)
                    cell.eventTitle.text = self.eventsThisWeek[indexPath.row].title
                    cell.eventDate.text = self.eventsThisWeek[indexPath.row].date
                    cell.eventDescription.text = self.eventsThisWeek[indexPath.row].evDescription
                }
                
            }
        }
        
        //------THIS MONTH
        else {
            let photo = self.eventsThisMonth[indexPath.row].pathToImage!
            
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
            
            cell.eventPhoto.isUserInteractionEnabled = true
            
            cell.eventPhoto.addGestureRecognizer(imageTap)
            
            if (self.eventsThisMonth[indexPath.row].evDescription.characters.count > 100){
                
                let index = self.eventsThisMonth[indexPath.row].evDescription.index(self.eventsThisMonth[indexPath.row].evDescription.startIndex, offsetBy: 100)
                
                
                if ((self.eventsThisMonth[indexPath.row].pathToImage) != "null"){
                    
                    
                    cell.eventPhoto.isHidden = false
                    cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                    
                    
                    let url = NSURL(string:photo)
                    
                    
                    cell.configure(eventTitle: self.eventsThisMonth[indexPath.row].title,
                                   eventDate: self.eventsThisMonth[indexPath.row].date,
                                   isVerified: self.eventsThisMonth[indexPath.row].verified,
                                   eventDescription: self.eventsThisMonth[indexPath.row].evDescription.substring(to: index) + "...",
                                   eventPhoto: self.eventsThisMonth[indexPath.row].pathToImage)
                    cell.eventPhoto.sd_setImage(with: url! as URL)
                    cell.interestCategory.image = UIImage(named: self.eventsThisMonth[indexPath.row].category)
                    
                    
                }
                    
                else{
                    cell.eventPhoto.isHidden = true
                    cell.imageViewHeightConstraint.constant = 0
                    cell.interestCategory.image = UIImage(named: self.eventsThisMonth[indexPath.row].category)
                    cell.eventTitle.text = self.eventsThisMonth[indexPath.row].title
                    cell.eventDate.text = self.eventsThisMonth[indexPath.row].date
                    cell.eventDescription.text = self.eventsThisMonth[indexPath.row].evDescription.substring(to: index) + "..."
                }
                
            }
                
            else {
                
                if ((self.eventsThisMonth[indexPath.row].pathToImage) != "null"){
                    
                    cell.eventPhoto.isHidden = false
                    cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                    
                    
                    let url = NSURL(string:photo)
                    
                    
                    
                    cell.configure(eventTitle: self.eventsThisMonth[indexPath.row].title,
                                   eventDate: self.eventsThisMonth[indexPath.row].date,
                                   isVerified: self.eventsThisMonth[indexPath.row].verified,
                                   eventDescription: self.eventsThisMonth[indexPath.row].evDescription,
                                   eventPhoto: self.eventsThisMonth[indexPath.row].pathToImage)
                    cell.eventPhoto.sd_setImage(with: url! as URL)
                    cell.interestCategory.image = UIImage(named: self.eventsThisMonth[indexPath.row].category)
                    
                }
                    
                else{
                    cell.eventPhoto.isHidden = true
                    cell.imageViewHeightConstraint.constant = 0
                    cell.interestCategory.image = UIImage(named: self.eventsThisMonth[indexPath.row].category)
                    cell.eventTitle.text = self.eventsThisMonth[indexPath.row].title
                    cell.eventDate.text = self.eventsThisMonth[indexPath.row].date
                    cell.eventDescription.text = self.eventsThisMonth[indexPath.row].evDescription
                }
                
            }
        }
        
        return (cell)
    }
    
    
    //Table View Cell Path According to Array
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white

        if (today == true){
            performSegue(withIdentifier: "eventInfoSegue", sender: eventsToday[indexPath.row].eventKey)

        }
        else if (thisWeek == true){
            performSegue(withIdentifier: "eventInfoSegue", sender: eventsThisWeek[indexPath.row].eventKey)

        }
        else{
            performSegue(withIdentifier: "eventInfoSegue", sender: eventsThisMonth[indexPath.row].eventKey)
        }
        
    }
    
    
    
    //Function called when clicking on an event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventInfoSegue"){
        let eventIn = segue.destination as! EventInfoViewController
        eventIn.eventKey = sender as! String
        }
        
    }


    func removeMenu(){
        trailingMenuConstraint.constant = -150
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        view.layoutIfNeeded()
        homeTableView.isUserInteractionEnabled = true
    }

    @IBAction func openMenu(_ sender: Any) {
        
        if (menuShowing){
            removeMenu()
        }
        else {
            
            homeTableView.isUserInteractionEnabled = false
            trailingMenuConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            view.layoutIfNeeded()
        }
        
        menuShowing = !menuShowing
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
        
        if (FIRAuth.auth()?.currentUser != nil){
            do{
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialView")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }

        
    }
    
    //Check if events loaded
    func checkEvents(){
        
        if (today == true){
    
            if (eventsToday.isEmpty){
                homeTableView.isHidden = true
                loadingView.isHidden = false
                noEventText.isHidden = false
            }
            else {
                loadingView.isHidden = true
                homeTableView.isHidden = false
            }
            
        }
        if (thisMonth == true){
            if (eventsThisMonth.isEmpty){
                homeTableView.isHidden = true
                loadingView.isHidden = false
                noEventText.isHidden = false
                noEventText.text = "Sorry. It looks like nothing you'd be interested in is happening this month :("
            }
            else {
                loadingView.isHidden = true
                homeTableView.isHidden = false

            }
        }
        
        if (thisWeek == true){
            if (eventsThisWeek.isEmpty){
                homeTableView.isHidden = true
                loadingView.isHidden = false
                noEventText.isHidden = false
                noEventText.text = "Sorry. It looks like nothing you'd be interested in is happening this week :("
            }
            else {
                loadingView.isHidden = true
                homeTableView.isHidden = false
            }
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
    
    func updateLocation(){
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        print("location updated")
    }
    
    //Menu Button Actions
    @IBAction func didPressToday(_ sender: Any) {
        thisWeek = false
        thisMonth = false
        today = true
        
        todayOption.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        thisWeekOption.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        thisMonthOption.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        removeMenu()
        checkEvents()
        
        UIView.transition(with: homeTableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.homeTableView.reloadData()}, completion: nil)
    }
    
    @IBAction func didPressThisWeek(_ sender: Any) {
        thisWeek = true
        thisMonth = false
        today = false
        checkEvents()
        
        thisWeekOption.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        todayOption.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        thisMonthOption.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        removeMenu()
        checkEvents()
        
        UIView.transition(with: homeTableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.homeTableView.reloadData()}, completion: nil)
        
    }
    @IBAction func didPressThisMonth(_ sender: Any) {
        thisWeek = false
        thisMonth = true
        today = false
        
        thisMonthOption.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        thisWeekOption.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        todayOption.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        removeMenu()
        checkEvents()
        
        UIView.transition(with: homeTableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.homeTableView.reloadData()}, completion: nil)
    }
    
    

}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
