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




class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var currentUser:  AnyObject?
    var currentUserData: FIRDatabaseReference!
    var currentBlock: FIRDatabaseReference!
    var modifiedDescription : String?
    
    var userInterests = ["none"]
    var userBlocks = ["key"]
    var interestHandle: FIRDatabaseHandle?
    var numberOfEvents = 0
    
    var defaultImageViewHeightConstraint:CGFloat = 225
    
    


    @IBOutlet weak var trailingMenuConstraint: NSLayoutConstraint!
    var menuShowing = false

    @IBOutlet weak var noEventsView: UIView!
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var navBack: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    var dataBaseRef: FIRDatabaseReference!
    var events = [Event]()



    fileprivate var _refHandle: FIRDatabaseHandle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.layer.shadowOpacity = 0.5
        menu.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        noEventsView.isHidden = true
        homeTableView.isHidden = true
        //Activity Indicator
        activityIndicator.startAnimating()
        
        
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
                let fraternityLife = interestDictionary["FRATERNITYLIFE"] as? Bool
                    if (fraternityLife == true){
                        if(self.userInterests.contains("FRATERNITYLIFE") == false){
                            self.userInterests.append("FRATERNITYLIFE")
                        
                    }
                }
                    if(fraternityLife == false){
                        if(self.userInterests.contains("FRATERNITYLIFE")){
                            let interestIndex = self.userInterests.index(of: "FRATERNITY")
                            self.userInterests.remove(at: interestIndex!)
                    }
                }
                let sororityLife = interestDictionary["SORORITYLIFE"] as? Bool
                if (sororityLife == true){
                    if(self.userInterests.contains("SORORITYLIFE") == false){
                        self.userInterests.append("SORORITYLIFE")
                        
                    }
                }
                if(sororityLife == false){
                    if(self.userInterests.contains("SORORITYLIFE")){
                        let interestIndex = self.userInterests.index(of: "SORORITYLIFE")
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
        
        
        checkEvents()

        activityIndicator.stopAnimating()

        
        
        
    }


    
    func configureDatabase(){
        
        //Organize event posts data
        self.dataBaseRef.child("Event").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snap) in
        
            //Check if category of the event fulfills the user's interests
            let eventSnap = snap.value as! [String: AnyObject]
            for (_,event) in eventSnap {
                if let eventCategory = event["category"] as? String {
                    for each in self.userInterests {
                        if (each == eventCategory){
                            if let eKey = event["uid"] as? String {
                                if(!self.userBlocks.contains(eKey)){
                                
                        //Event data
                        let eventPost = Event()
                        if let category = event["category"] as? String, let date = event["date"] as? String, let evDescription = event["evDescription"] as? String, let time = event["time"] as? String, let title = event["title"] as? String, let uid = event["uid"] as? String, let username = event["username"] as? String, let pathToImage = event["pathToImage"] as? String, let verified = event["verified"] as? String, let eventKey = event["eventKey"] as? String, let paid = event["paid"] as? String, let radius = event["radius"] as? String{
                            eventPost.category = category
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
                        
                            
                            
                            self.events.append(eventPost)
                            self.numberOfEvents += 1
                            
                            
                            print(self.events)
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
        return self.events.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeCell
        
        let photo = self.events[indexPath.row].pathToImage!
        
        if (self.events[indexPath.row].evDescription.characters.count > 100){
            
        let index = self.events[indexPath.row].evDescription.index(self.events[indexPath.row].evDescription.startIndex, offsetBy: 100)
        
        
        if ((self.events[indexPath.row].pathToImage) != "null"){
            
            cell.eventPhoto.isHidden = false
            cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
            
            
            let url = NSURL(string:photo)
            
            cell.eventPhoto.layer.cornerRadius = 15

            
            cell.configure(eventTitle: self.events[indexPath.row].title,
                           eventDate: self.events[indexPath.row].date,
                           isVerified: self.events[indexPath.row].verified,
                           eventDescription: self.events[indexPath.row].evDescription.substring(to: index) + "...",
                           eventPhoto: self.events[indexPath.row].pathToImage)
            cell.eventPhoto.sd_setImage(with: url! as URL)
            cell.interestCategory.image = UIImage(named: self.events[indexPath.row].category)
    
        }
            
        else{
            cell.eventPhoto.isHidden = true
            cell.imageViewHeightConstraint.constant = 0
            cell.interestCategory.image = UIImage(named: self.events[indexPath.row].category)
            cell.eventTitle.text = self.events[indexPath.row].title
            cell.eventDate.text = self.events[indexPath.row].date
            cell.eventDescription.text = self.events[indexPath.row].evDescription.substring(to: index) + "..."
        }
            
        }
        
        else {
            
            if ((self.events[indexPath.row].pathToImage) != "null"){
                
                cell.eventPhoto.isHidden = false
                cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                
                
                let url = NSURL(string:photo)
                
                cell.eventPhoto.layer.cornerRadius = 15
                
                
                cell.configure(eventTitle: self.events[indexPath.row].title,
                               eventDate: self.events[indexPath.row].date,
                               isVerified: self.events[indexPath.row].verified,
                               eventDescription: self.events[indexPath.row].evDescription,
                               eventPhoto: self.events[indexPath.row].pathToImage)
                cell.eventPhoto.sd_setImage(with: url! as URL)
                cell.interestCategory.image = UIImage(named: self.events[indexPath.row].category)
                
            }
                
            else{
                cell.eventPhoto.isHidden = true
                cell.imageViewHeightConstraint.constant = 0
                cell.interestCategory.image = UIImage(named: self.events[indexPath.row].category)
                cell.eventTitle.text = self.events[indexPath.row].title
                cell.eventDate.text = self.events[indexPath.row].date
                cell.eventDescription.text = self.events[indexPath.row].evDescription
            }
            
        }
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventInfoSegue", sender: events[indexPath.row].eventKey)
        
    }
    
    //Function called when clicking on an event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventInfoSegue"){
        let eventIn = segue.destination as! EventInfoViewController
        eventIn.eventKey = sender as! String
        }
        
    }


    

    @IBAction func openMenu(_ sender: Any) {
        
        if (menuShowing){
            trailingMenuConstraint.constant = -140
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            view.layoutIfNeeded()
        }
        else {
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
        
        if (numberOfEvents == 0){
        
            self.homeTableView.isHidden = true
            self.noEventsView.isHidden = false
            
        }
    }


}
