//
//  EventsTableViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 4/24/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import SDWebImage
import CoreLocation

class EventsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noEventImg: UIImageView!
    @IBOutlet weak var noEventLbl: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var todayBtn: UIButtonX!
    @IBOutlet weak var tomorrowBtn: UIButtonX!
    @IBOutlet weak var thisWeekBtn: UIButtonX!
    @IBOutlet weak var thisMonthBtn: UIButtonX!
    @IBOutlet weak var laterBtn: UIButtonX!
    
    //Database Variables
    var database = Firestore.firestore()
    var webblenEvents = [webblenEvent]()
    var todayArray = [webblenEvent]()
    var tomorrowArray = [webblenEvent]()
    var thisWeekArray = [webblenEvent]()
    var thisMonthArray = [webblenEvent]()
    var laterArray = [webblenEvent]()
    
    //User Interests & Blocks
    var currentUser = Auth.auth().currentUser
    var userInterests = [""]
    var userBlocks = [""]
    
    //Geotification & Event Variables
    var coordinates: [CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    var closestEventKey: String?
    var closestEventTitle: String?
    var closestEventIsHidden = false
    var distanceFromEvent = 10000.0
    
    var formatter = DateFormatter()
    var dateCalendar = Calendar.current
    
    //Extras
    var activeColor = UIColor(red: 30/300, green: 39/300, blue: 46/300, alpha: 1.0)
    var inactiveColor = UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0)
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
        loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: activeColor, padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        //Date Format
        formatter.dateFormat = "MM/dd/yyyy"
        loadEvents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadEvents(){
        let userRef = database.collection("users").document((currentUser?.uid)!)
        //Check if user exists
        userRef.getDocument(completion: {(document, error) in
            if let document = document {
                if !(document.exists){
                    self.performSegue(withIdentifier: "setupSegue", sender: nil)
                }
                else {
                    //If users exists load interests and blocked users
                    self.userInterests = (document.data()!["interests"] as? [String])!
                    self.userBlocks = (document.data()!["blockedUsers"] as? [String])!
                    let eventRef = self.database.collection("events").getDocuments(completion: {(snapshot, error) in
                        if let error = error {
                            print("error in finding events")
                        }
                        else{
                            //Load Events aligning with user's interests
                            let formattedDate = self.formatter.string(from: Date())
                            for event in snapshot!.documents {
                                let eventCategories = (event.data()["categories"] as? [String])!
                                for i in self.userInterests {
                                    if eventCategories.contains(i){
                                        var interestedEvent = webblenEvent(
                                            title: event.data()["title"] as! String,
                                            address: event.data()["address"] as! String,
                                            categories: eventCategories,
                                            date: event.data()["date"] as! String,
                                            description: event.data()["description"] as! String,
                                            eventKey: event.data()["eventKey"] as! String,
                                            lat: event.data()["lat"] as! Double,
                                            lon: event.data()["lon"] as! Double,
                                            paid: event.data()["paid"] as! Bool,
                                            pathToImage: event.data()["pathToImage"] as! String,
                                            radius: event.data()["radius"] as! Double,
                                            time: event.data()["time"] as! String,
                                            author: event.data()["author"] as! String,
                                            verified: event.data()["verified"] as! Bool,
                                            views: event.data()["views"] as! Int,
                                            event18: event.data()["event18"] as! Bool,
                                            event21: event.data()["event21"] as! Bool,
                                            notificationOnly: event.data()["notificationOnly"] as! Bool,
                                            distanceFromUser: 0
                                        )
                                        
                                        let currentDate = self.formatter.date(from: formattedDate)
                                        let eventDate = self.formatter.date(from: interestedEvent.date)
                                        
                                        //Organize Loaded Events By Date
                                        let currentCalendarDate = self.dateCalendar.dateComponents([.month, .day, .year], from: currentDate!)
                                        let eventCalendarDate = self.dateCalendar.dateComponents([.month, .day, .year], from: eventDate!)
                                        let daysBetweenEvents = self.dateCalendar.dateComponents([.day], from: currentDate!, to: eventDate!)
                                        print(daysBetweenEvents.day)
                                        let monthsBetweenEvents = self.dateCalendar.dateComponents([.month], from: currentDate!, to: eventDate!)
                                        
                                        
                                        //Append to Event Date Arrays
                                        if (eventDate! < currentDate! && interestedEvent.paid) {
                                            self.database.collection("events").document(interestedEvent.eventKey).delete()
                                        }
                                        else if (currentDate! == eventDate! && interestedEvent.paid) {
                                            if (self.userBlocks.contains(interestedEvent.author)) == false{
                                                let result = self.webblenEvents.filter { $0.title == interestedEvent.title }
                                                if result.isEmpty {
                                                 self.webblenEvents.append(interestedEvent)
                                                }
                                                let todayResult = self.todayArray.filter { $0.title == interestedEvent.title }
                                                if todayResult.isEmpty {
                                                    self.todayArray.append(interestedEvent)
                                                }
                                                
                                            }
                                        }
                                        else if (daysBetweenEvents.day! == 1 && interestedEvent.paid) {
                                            if (self.userBlocks.contains(interestedEvent.author)) == false{
                                                let result = self.tomorrowArray.filter { $0.title == interestedEvent.title }
                                                if result.isEmpty {
                                                    self.tomorrowArray.append(interestedEvent)
                                                }
                                            }
                                        }
                                        else if (daysBetweenEvents.day! > 1 && daysBetweenEvents.day! < 8 && interestedEvent.paid) {
                                            if (self.userBlocks.contains(interestedEvent.author)) == false{
                                                let result = self.thisWeekArray.filter { $0.title == interestedEvent.title }
                                                if result.isEmpty {
                                                    self.thisWeekArray.append(interestedEvent)
                                                }
                                            }
                                        }
                                        else if (daysBetweenEvents.day! >= 8 && daysBetweenEvents.day! <= 31 && interestedEvent.paid) {
                                            if (self.userBlocks.contains(interestedEvent.author)) == false{
                                                let result = self.thisMonthArray.filter { $0.title == interestedEvent.title }
                                                if result.isEmpty {
                                                    self.thisMonthArray.append(interestedEvent)
                                                }                                            }
                                        }
                                        else {
                                            if ((self.userBlocks.contains(interestedEvent.author)) == false) && interestedEvent.paid{
                                                let result = self.laterArray.filter { $0.title == interestedEvent.title }
                                                if result.isEmpty {
                                                    self.laterArray.append(interestedEvent)
                                                }
                                            }
                                        }
                                        
                                    }

                                }
                            }
                            if self.webblenEvents.count == 0 {
                                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                                    self.eventsTableView.reloadData()
                                    self.eventsTableView.isHidden = true
                                    self.noEventImg.isHidden = false
                                    self.noEventLbl.isHidden = false
                                }, completion: { _ in self.loadingView.stopAnimating()})
                            } else {
                                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                                    self.eventsTableView.reloadData()
                                    self.eventsTableView.isHidden = false
                                    self.noEventImg.isHidden = true
                                    self.noEventLbl.isHidden = true
                                }, completion: { _ in self.loadingView.stopAnimating() })
                            }
                            
                        }
                        
                    })
                }
            }
            else {
                print("document does not exist")
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.webblenEvents.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let imageURL = self.webblenEvents[indexPath.row].pathToImage
        let author = self.webblenEvents[indexPath.row].author
        var eDesc = self.webblenEvents[indexPath.row].description
        
        if eDesc.count > 250{
            eDesc = eDesc.prefix(250) + "..."
        }
        
        if (imageURL != ""){
            cell = eventsTableView.dequeueReusableCell(withIdentifier: "eventImgCell")!
            let eventImage = cell.viewWithTag(1) as! UIImageViewX
            eventImage.image = nil
            let eventCatImg = cell.viewWithTag(2) as! UIImageViewX
            let eventTitle = cell.viewWithTag(3) as! UILabel
            let eventAuthor = cell.viewWithTag(4) as! UILabel
            let eventViews = cell.viewWithTag(5) as! UILabel
            let eventDescription = cell.viewWithTag(6) as! UITextView
            let eventSmallCat1 = cell.viewWithTag(7) as! UIImageView
            let eventSmallCat2 = cell.viewWithTag(8) as! UIImageView
            let separator = cell.viewWithTag(11) as! UIImageView
            if self.webblenEvents[indexPath.row].title == self.webblenEvents[0].title {
                separator.isHidden = true
            }
            //let eventSmallCat3 = cell.viewWithTag(9) as! UIImageView
            
            let url = NSURL(string: imageURL)
            eventImage.sd_setImage(with: url! as URL, placeholderImage: nil)
            eventImage.layer.cornerRadius = 25
            eventImage.clipsToBounds = true;
            eventCatImg.image = UIImage(named: self.webblenEvents[indexPath.row].categories.first!)
            eventTitle.text = self.webblenEvents[indexPath.row].title
            eventAuthor.text = "@" + author
            let views = String(self.webblenEvents[indexPath.row].views)
            eventViews.text = views
            eventDescription.text = eDesc
            if self.webblenEvents[indexPath.row].categories.count > 1{
                eventSmallCat1.image = UIImage(named: self.webblenEvents[indexPath.row].categories[1])
            }
            if self.webblenEvents[indexPath.row].categories.count > 2{
                eventSmallCat2.image = UIImage(named: self.webblenEvents[indexPath.row].categories[2])
            }
        } else {
            cell = eventsTableView.dequeueReusableCell(withIdentifier: "eventCell")!
            let eventCatImg = cell.viewWithTag(2) as! UIImageViewX
            let eventTitle = cell.viewWithTag(3) as! UILabel
            let eventAuthor = cell.viewWithTag(4) as! UILabel
            let eventViews = cell.viewWithTag(5) as! UILabel
            let eventDescription = cell.viewWithTag(6) as! UITextView
            let eventSmallCat1 = cell.viewWithTag(7) as! UIImageView
            let eventSmallCat2 = cell.viewWithTag(8) as! UIImageView
            let separator = cell.viewWithTag(11) as! UIImageView
            if self.webblenEvents[indexPath.row].title == self.webblenEvents[0].title {
                separator.isHidden = true
            }
            //let eventSmallCat3 = cell.viewWithTag(9) as! UIImageView
            
            eventCatImg.image = UIImage(named: self.webblenEvents[indexPath.row].categories.first!)
            eventTitle.text = self.webblenEvents[indexPath.row].title
            eventAuthor.text = "@" + author
            let views = String(self.webblenEvents[indexPath.row].views)
            eventViews.text = views
            eventDescription.text = eDesc
            if self.webblenEvents[indexPath.row].categories.count > 1{
                eventSmallCat1.image = UIImage(named: self.webblenEvents[indexPath.row].categories[1])
            }
            if self.webblenEvents[indexPath.row].categories.count > 2{
                eventSmallCat2.image = UIImage(named: self.webblenEvents[indexPath.row].categories[2])
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventInfoSegue", sender: webblenEvents[indexPath.row].eventKey)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EventInfoSegue"){
            let eventIn = segue.destination as! EventInfoViewController
            eventIn.eventKey = sender as! String
        }
    }

    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressToday(_ sender: Any) {
        todayBtn.setTitleColor(activeColor, for: .normal)
        tomorrowBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        thisWeekBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        thisMonthBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        laterBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)

        
        webblenEvents = todayArray
        print(webblenEvents)
        eventsTableView.reloadData()
        eventsTableView.contentOffset = CGPoint(x: 0, y: 0 - eventsTableView.contentInset.top)
        if self.webblenEvents.count == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = true
                self.noEventImg.isHidden = false
                self.noEventLbl.isHidden = false
                self.noEventLbl.text = "Shoot! It Doesn't Look Like Anything is Happening Today..."
            }, completion: { _ in self.loadingView.stopAnimating()})
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = false
                self.noEventImg.isHidden = true
                self.noEventLbl.isHidden = true
            }, completion: { _ in self.loadingView.stopAnimating() })
        }
    }
    @IBAction func didPressTomorrow(_ sender: Any) {
        todayBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        tomorrowBtn.setTitleColor(activeColor, for: .normal)
        thisWeekBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        thisMonthBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        laterBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)

        
        webblenEvents = tomorrowArray
        //print(webblenEvents)
        eventsTableView.reloadData()
        eventsTableView.contentOffset = CGPoint(x: 0, y: 0 - eventsTableView.contentInset.top)
        if self.webblenEvents.count == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = true
                self.noEventImg.isHidden = false
                self.noEventLbl.isHidden = false
                self.noEventLbl.text = "Shoot! It Doesn't Look Like Anything is Happening Tomorrow..."
            }, completion: { _ in self.loadingView.stopAnimating()})
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = false
                self.noEventImg.isHidden = true
                self.noEventLbl.isHidden = true
            }, completion: { _ in self.loadingView.stopAnimating() })
        }
    }
    
    @IBAction func didPressThisWeek(_ sender: Any) {
        todayBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        tomorrowBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        thisWeekBtn.setTitleColor(activeColor, for: .normal)
        thisMonthBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        laterBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        
        webblenEvents = thisWeekArray
        //print(webblenEvents)
        eventsTableView.reloadData()
        eventsTableView.contentOffset = CGPoint(x: 0, y: 0 - eventsTableView.contentInset.top)
        if self.webblenEvents.count == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = true
                self.noEventImg.isHidden = false
                self.noEventLbl.isHidden = false
                self.noEventLbl.text = "Shoot! It Doesn't Look Like Anything is Happening Later This Week..."
            }, completion: { _ in self.loadingView.stopAnimating()})
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = false
                self.noEventImg.isHidden = true
                self.noEventLbl.isHidden = true
            }, completion: { _ in self.loadingView.stopAnimating() })
        }
    }
    @IBAction func didPressThisMonth(_ sender: Any) {
        todayBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        tomorrowBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        thisWeekBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        thisMonthBtn.setTitleColor(activeColor, for: .normal)
        laterBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        
        webblenEvents = thisMonthArray
        //print(webblenEvents)
        eventsTableView.reloadData()
        eventsTableView.contentOffset = CGPoint(x: 0, y: 0 - eventsTableView.contentInset.top)
        if self.webblenEvents.count == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = true
                self.noEventImg.isHidden = false
                self.noEventLbl.isHidden = false
                self.noEventLbl.text = "Shoot! It Doesn't Look Like Anything is Happening Later This Month..."
            }, completion: { _ in self.loadingView.stopAnimating()})
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = false
                self.noEventImg.isHidden = true
                self.noEventLbl.isHidden = true
            }, completion: { _ in self.loadingView.stopAnimating() })
        }
    }
    @IBAction func didPressLater(_ sender: Any) {
        todayBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        tomorrowBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        thisWeekBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        thisMonthBtn.setTitleColor(UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0), for: .normal)
        laterBtn.setTitleColor(activeColor, for: .normal)
        
        webblenEvents = laterArray
        //print(webblenEvents)
        eventsTableView.reloadData()
        eventsTableView.contentOffset = CGPoint(x: 0, y: 0 - eventsTableView.contentInset.top)
        if self.webblenEvents.count == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = true
                self.noEventImg.isHidden = false
                self.noEventLbl.isHidden = false
                self.noEventLbl.text = "Shoot! It Doesn't Look Like Anything is Happening Later..."
            }, completion: { _ in self.loadingView.stopAnimating()})
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = false
                self.noEventImg.isHidden = true
                self.noEventLbl.isHidden = true
            }, completion: { _ in self.loadingView.stopAnimating() })
        }
    }
    
    
}
