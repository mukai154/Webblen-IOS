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
    var currentUserData: DatabaseReference!
    var currentBlock: DatabaseReference!
    var modifiedDescription : String?
    
    var userInterests = ["none"]
    var userBlocks = ["key"]
    var interestHandle: DatabaseHandle?
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
    
    
    var dataBaseRef: DatabaseReference!
    
    //Event Date Organzation
    var events = [webblenEvent]()
    var eventsToday = [webblenEvent]()
    var eventsThisWeek = [webblenEvent]()
    var eventsThisMonth = [webblenEvent]()
    
    var today = true
    var thisWeek = false
    var thisMonth = false
    
    var currentDate = Date()
    var formatter = DateFormatter()
    
    var tableCount = 0
    




    fileprivate var _refHandle: DatabaseHandle!
    
    
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
        

        
        
        //Activity Indicator
        
        
        
        //Database Reference
        dataBaseRef = Database.database().reference()

        //User Reference
        self.currentUser = Auth.auth().currentUser
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
        
        self.currentUser = Auth.auth().currentUser
        
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.estimatedRowHeight = 250
        
    }


    
    func configureDatabase(){
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
        
            let photo = self.eventsToday[indexPath.row].pathToImage
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
        
        cell.eventPhoto.isUserInteractionEnabled = true
        
        cell.eventPhoto.addGestureRecognizer(imageTap)
        
        if (self.eventsToday[indexPath.row].description.characters.count > 100){
            
            let index = self.eventsToday[indexPath.row].description.index(self.eventsToday[indexPath.row].description.startIndex, offsetBy: 100)
            
            
            if ((self.eventsToday[indexPath.row].pathToImage) != "null"){
                
                
                cell.eventPhoto.isHidden = false
                cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                
                
                let url = NSURL(string:photo)
                
                
                cell.configure(eventTitle: self.eventsToday[indexPath.row].title,
                               eventDate: self.eventsToday[indexPath.row].date,
                               isVerified: self.eventsToday[indexPath.row].verified,
                               eventDescription: self.eventsToday[indexPath.row].description.substring(to: index) + "...",
                               eventPhoto: self.eventsToday[indexPath.row].pathToImage)
                cell.eventPhoto.sd_setImage(with: url! as URL)
                cell.interestCategory.image = UIImage(named: self.eventsToday[indexPath.row].categories.first!)
                
                
            }
                
            else{
                cell.eventPhoto.isHidden = true
                cell.imageViewHeightConstraint.constant = 0
                cell.interestCategory.image = UIImage(named: self.eventsToday[indexPath.row].categories.first!)
                cell.eventTitle.text = self.eventsToday[indexPath.row].title
                cell.eventDate.text = self.eventsToday[indexPath.row].date
                cell.eventDescription.text = self.eventsToday[indexPath.row].description.substring(to: index) + "..."
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
                               eventDescription: self.eventsToday[indexPath.row].description,
                               eventPhoto: self.eventsToday[indexPath.row].pathToImage)
                cell.eventPhoto.sd_setImage(with: url! as URL)
                cell.interestCategory.image = UIImage(named: self.eventsToday[indexPath.row].categories.first!)
                
            }
                
            else{
                cell.eventPhoto.isHidden = true
                cell.imageViewHeightConstraint.constant = 0
                cell.interestCategory.image = UIImage(named: self.eventsToday[indexPath.row].categories.first!)
                cell.eventTitle.text = self.eventsToday[indexPath.row].title
                cell.eventDate.text = self.eventsToday[indexPath.row].date
                cell.eventDescription.text = self.eventsToday[indexPath.row].description
            }
            
        }
        }
            
        //------THIS WEEK
        else if (thisWeek == true){
            let photo = self.eventsThisWeek[indexPath.row].pathToImage
            
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
            
            cell.eventPhoto.isUserInteractionEnabled = true
            
            cell.eventPhoto.addGestureRecognizer(imageTap)
            
            if (self.eventsThisWeek[indexPath.row].description.characters.count > 100){
                
                let index = self.eventsThisWeek[indexPath.row].description.index(self.eventsThisWeek[indexPath.row].description.startIndex, offsetBy: 100)
                
                
                if ((self.eventsThisWeek[indexPath.row].pathToImage) != "null"){
                    
                    
                    cell.eventPhoto.isHidden = false
                    cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                    
                    
                    let url = NSURL(string:photo)
                    
                    
                    cell.configure(eventTitle: self.eventsThisWeek[indexPath.row].title,
                                   eventDate: self.eventsThisWeek[indexPath.row].date,
                                   isVerified: self.eventsThisWeek[indexPath.row].verified,
                                   eventDescription: self.eventsThisWeek[indexPath.row].description.substring(to: index) + "...",
                                   eventPhoto: self.eventsThisWeek[indexPath.row].pathToImage)
                    cell.eventPhoto.sd_setImage(with: url! as URL)
                    cell.interestCategory.image = UIImage(named: self.eventsThisWeek[indexPath.row].categories.first!)
                    
                    
                }
                    
                else{
                    cell.eventPhoto.isHidden = true
                    cell.imageViewHeightConstraint.constant = 0
                    cell.interestCategory.image = UIImage(named: self.eventsThisWeek[indexPath.row].categories.first!)
                    cell.eventTitle.text = self.eventsThisWeek[indexPath.row].title
                    cell.eventDate.text = self.eventsThisWeek[indexPath.row].date
                    cell.eventDescription.text = self.eventsThisWeek[indexPath.row].description.substring(to: index) + "..."
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
                                   eventDescription: self.eventsThisWeek[indexPath.row].description,
                                   eventPhoto: self.eventsThisWeek[indexPath.row].pathToImage)
                    cell.eventPhoto.sd_setImage(with: url! as URL)
                    cell.interestCategory.image = UIImage(named: self.eventsThisWeek[indexPath.row].categories.first!)
                }
                    
                else{
                    cell.eventPhoto.isHidden = true
                    cell.imageViewHeightConstraint.constant = 0
                    cell.interestCategory.image = UIImage(named: self.eventsThisWeek[indexPath.row].categories.first!)
                    cell.eventTitle.text = self.eventsThisWeek[indexPath.row].title
                    cell.eventDate.text = self.eventsThisWeek[indexPath.row].date
                    cell.eventDescription.text = self.eventsThisWeek[indexPath.row].description
                }
            }
        }
        
        //------THIS MONTH
        else {
            let photo = self.eventsThisMonth[indexPath.row].pathToImage
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapEventPhoto))
            cell.eventPhoto.isUserInteractionEnabled = true
            cell.eventPhoto.addGestureRecognizer(imageTap)
            
            if (self.eventsThisMonth[indexPath.row].description.characters.count > 100){
                let index = self.eventsThisMonth[indexPath.row].description.index(self.eventsThisMonth[indexPath.row].description.startIndex, offsetBy: 100)
                if ((self.eventsThisMonth[indexPath.row].pathToImage) != "null"){
                    
                    
                    cell.eventPhoto.isHidden = false
                    cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                    
                    
                    let url = NSURL(string:photo)
                    
                    
                    cell.configure(eventTitle: self.eventsThisMonth[indexPath.row].title,
                                   eventDate: self.eventsThisMonth[indexPath.row].date,
                                   isVerified: self.eventsThisMonth[indexPath.row].verified,
                                   eventDescription: self.eventsThisMonth[indexPath.row].description.substring(to: index) + "...",
                                   eventPhoto: self.eventsThisMonth[indexPath.row].pathToImage)
                    cell.eventPhoto.sd_setImage(with: url! as URL)
                    cell.interestCategory.image = UIImage(named: self.eventsThisMonth[indexPath.row].categories.first!)
                }
                    
                else{
                    cell.eventPhoto.isHidden = true
                    cell.imageViewHeightConstraint.constant = 0
                    cell.interestCategory.image = UIImage(named: self.eventsThisMonth[indexPath.row].categories.first!)
                    cell.eventTitle.text = self.eventsThisMonth[indexPath.row].title
                    cell.eventDate.text = self.eventsThisMonth[indexPath.row].date
                    cell.eventDescription.text = self.eventsThisMonth[indexPath.row].description.substring(to: index) + "..."
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
                                   eventDescription: self.eventsThisMonth[indexPath.row].description,
                                   eventPhoto: self.eventsThisMonth[indexPath.row].pathToImage)
                    cell.eventPhoto.sd_setImage(with: url! as URL)
                    cell.interestCategory.image = UIImage(named: self.eventsThisMonth[indexPath.row].categories.first!)
                    
                }
                    
                else{
                    cell.eventPhoto.isHidden = true
                    cell.imageViewHeightConstraint.constant = 0
                    cell.interestCategory.image = UIImage(named: self.eventsThisMonth[indexPath.row].categories.first!)
                    cell.eventTitle.text = self.eventsThisMonth[indexPath.row].title
                    cell.eventDate.text = self.eventsThisMonth[indexPath.row].date
                    cell.eventDescription.text = self.eventsThisMonth[indexPath.row].description
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
        
        if (Auth.auth().currentUser != nil){
            do{
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialView")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    }
    
    //Menu options
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


