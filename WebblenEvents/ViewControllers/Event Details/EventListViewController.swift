//
//  EventListViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 7/15/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import SDWebImage
import CoreLocation
import Hero

class EventListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource{

    //Date
    var formatter = DateFormatter()
    var dateCalendar = Calendar.current
    var calendarOptions = ["Today", "Tomorrow", "This Week", "Next Week", "This Month", "Later"]
    var selectedCalendarOption = "Today"
    var myEvents = false
    var initialLoad = true
    
    //Firebase
    var database = Firestore.firestore()
    var imageStorage = Storage.storage().reference(forURL: "gs://webblen-events.appspot.com/events")
    var webblenEvents = [EventPost]()
    var todayArray = [EventPost]()
    var tomorrowArray = [EventPost]()
    var thisWeekArray = [EventPost]()
    var nextWeekArray = [EventPost]()
    var thisMonthArray = [EventPost]()
    var laterArray = [EventPost]()
    
    //User
    var currentUser = Auth.auth().currentUser
    var username:String?
    var testTags = ["fitness", "gaming", "business", "food"]
    var userTags = [String]()
    var userBlocks = [String]()
    
    //Geotification & Event Variables
    var coordinates: [CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    var closestEventKey: String?
    var closestEventTitle: String?
    var closestEventIsHidden = false
    var distanceFromEvent = 10000.0
    // ~1 mile of lat and lon in degrees
    var mileLat = 0.0144927536231884
    var mileLon = 0.0181818181818182
    
    //UI
    @IBOutlet weak var navigationBackground: UIViewX!
    @IBOutlet weak var navigationLbl: UILabel!
    @IBOutlet weak var calendarSelectCollectionView: UICollectionView!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var noEventImg: UIImageView!
    @IBOutlet weak var noEventLabel: UILabel!
    
    //Colors & LoadingView
    var myEventsColor = UIColor(red: 104/255, green: 109/255, blue: 224/255, alpha: 1.0)
    var activeBtnColor = UIColor.white
    var inactiveBtnColor = UIColor.clear
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeroIDs()
        if myEvents {
            navigationLbl.text = "My Events"
            navigationBackground.backgroundColor = myEventsColor
        }
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-25), y: (yAxis-25), width: 50, height: 50)
        loadingView = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: activeBtnColor, padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        locationAccessCheck()
    }
    
    //Override Status Bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.calendarSelectCollectionView.delegate = self
    }
        
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setHeroIDs(){
        //Set Hero
        self.hero.isEnabled = true
        if myEvents {
            navigationBackground.hero.id = "calendar"
        } else {
            navigationBackground.hero.id = "list"
        }
        
    }

    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Load Data from Firestore
    func loadEventData(userLat: Double, userLon: Double, withinDistance: Double){
        //Max & Min Geopoints
        let lowerLat = userLat - (self.mileLat * withinDistance)
        let lowerLon = userLon - (self.mileLon * withinDistance)
        let greaterLat = userLat + (self.mileLat * withinDistance)
        let greaterLon = userLat + (self.mileLon * withinDistance)
        //Date Formatter
        formatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = self.formatter.string(from: Date())
        let userRef = database.collection("users").document((currentUser?.uid)!)
        let eventRef = database.collection("eventposts").whereField("lon", isGreaterThan: lowerLon).whereField("lon", isLessThan: greaterLon)
        //Check if user exists
        userRef.getDocument(completion: {(document, error) in
            if let document = document {
                if !(document.exists){
                    self.performSegue(withIdentifier: "setupSegue", sender: nil)
                } else {
                    //If users exists load interests and blocked users
                    self.userTags = document.data()!["tags"] as? [String] ?? self.testTags
                    self.userBlocks = (document.data()!["blockedUsers"] as? [String])!
                    eventRef.getDocuments(completion: {(snapshot, error) in
                        if let error = error {
                            self.showBlurAlert(title: "Event Load Error", message: "There Was an Issue Loading Events")
                        } else {
                            //Load Events aligning with user's interests
                            for event in snapshot!.documents {
                                let eventTags = Set((event.data()["tags"] as? [String])!)
                                let eventAuthor = (event.data()["author"] as? String)!
                                let eventLat = (event.data()["lat"] as? Double)!
                                let isInterested = eventTags.intersects(with: self.userTags)
                                print(isInterested)
                                let isNotBlocked = !(self.userBlocks.contains(eventAuthor))
                                print(isNotBlocked)
                                let isInRange = lowerLat...greaterLat ~= eventLat
                                print(isInRange)
                                if eventTags.intersects(with: self.userTags) && !(self.userBlocks.contains(eventAuthor)) && lowerLat...greaterLat ~= eventLat{
                                    var interestedEvent = EventPost(
                                        eventKey: event.documentID,
                                        title: event.data()["title"] as? String ?? "",
                                        caption: event.data()["caption"] as? String ?? "",
                                        description: event.data()["description"] as? String ?? "",
                                        pathToImage: event.data()["pathToImage"] as? String ?? "",
                                        uploadedImage: "",
                                        address: event.data()["address"] as? String ?? "",
                                        lat: event.data()["lat"] as? Double ?? 0.00,
                                        lon: event.data()["lon"] as? Double ?? 0.00,
                                        radius: event.data()["radius"] as? Double ?? 0.00,
                                        distanceFromUser: 0.0,
                                        tags: event.data()["tags"] as? [String] ?? [],
                                        startDate: event.data()["startDate"] as? String ?? formattedDate,
                                        endDate: event.data()["endDate"] as? String ?? formattedDate,
                                        startTime: event.data()["startTime"] as? String ?? "",
                                        endTime: event.data()["endTime"] as? String ?? "",
                                        published: event.data()["published"] as? Bool ?? true,
                                        hasMessageBoard: event.data()["published"] as? Bool ?? false,
                                        messageBoardPassword: event.data()["messageBoardPassword"] as? String ?? "",
                                        author: event.data()["author"] as? String ?? "",
                                        authorImagePath: event.data()["authorImagePath"] as? String ?? "",
                                        verified: event.data()["verified"] as? Bool ?? true,
                                        promoted: event.data()["promoted"] as? Bool ?? false,
                                        views: event.data()["views"] as? Int ?? 0,
                                        event18: event.data()["event18"] as? Bool ?? true,
                                        event21: event.data()["event21"] as? Bool ?? true,
                                        explicit: event.data()["explicit"] as? Bool ?? false,
                                        attendanceRecordID: event.data()["attendanceRecordID"] as? String ?? "",
                                        spotsAvailable: event.data()["spotsAvailable"] as? Int ?? 0,
                                        reservePrice: event.data()["radius"] as? Double ?? 0.00,
                                        website: event.data()["website"] as? String ?? "",
                                        fbSite: event.data()["fbSite"] as? String ?? "",
                                        twitterSite: event.data()["twitterSite"] as? String ?? "")
                                    print(interestedEvent)
                                    let currentDate = Date(fromString: formattedDate, format: .webblenFormat)
                                    let eventDate = Date(fromString: interestedEvent.startDate, format: .webblenFormat)
                                    
                                    if eventDate!.compare(.isInThePast) {
                                        let imagePath = interestedEvent.eventKey + ".jpg"
                                        self.imageStorage.child(imagePath).delete { error in
                                            if let error = error {}
                                        }
                                        self.database.collection("eventposts").document(interestedEvent.eventKey).delete()
                                    } else if eventDate!.compare(.isToday) {
                                        //print("eventToday")
                                        self.todayArray.append(interestedEvent)
                                        self.webblenEvents.append(interestedEvent)
                                    } else if eventDate!.compare(.isTomorrow) {
                                        //print("eventTomorrow")
                                        self.tomorrowArray.append(interestedEvent)
                                    } else if eventDate!.compare(.isThisWeek) {
                                        //print("eventThisWeek")
                                        self.thisWeekArray.append(interestedEvent)
                                    } else if eventDate!.compare(.isNextWeek) {
                                       // print("eventNextWeek")
                                        self.nextWeekArray.append(interestedEvent)
                                    } else if eventDate!.compare(.isThisMonth) {
                                       // print("eventThisMonth")
                                        self.thisMonthArray.append(interestedEvent)
                                    } else {
                                       // print("eventLater")
                                        self.laterArray.append(interestedEvent)
                                    }
                                }
                            }
                            self.loadingView.stopAnimating()
                            self.eventTableView.reloadData()
                            self.checkForEvents()
                        }
                    })
                }
            }
        })
    }
    
    //Load Personal Events from Firestore
    func loadPersonalEvents(){
        //Date Formatter
        formatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = self.formatter.string(from: Date())
        let userRef = database.collection("users").document((currentUser?.uid)!)
        //Check if user exists
        userRef.getDocument(completion: {(document, error) in
            if let document = document {
                if !(document.exists){
                    self.performSegue(withIdentifier: "setupSegue", sender: nil)
                } else {
                    self.username = (document.data()!["username"] as? String)!
                    let eventRef = self.database.collection("eventposts").whereField("author", isEqualTo: self.username!)
                    eventRef.getDocuments(completion: {(snapshot, error) in
                        if error != nil {
                            self.showBlurAlert(title: "Event Load Error", message: "There Was an Issue Loading Events")
                        } else {
                            //Load Events aligning with user's interests
                            for event in snapshot!.documents {
                                    var interestedEvent = EventPost(
                                        eventKey: event.documentID,
                                        title: event.data()["title"] as? String ?? "",
                                        caption: event.data()["caption"] as? String ?? "",
                                        description: event.data()["description"] as? String ?? "",
                                        pathToImage: event.data()["pathToImage"] as? String ?? "",
                                        uploadedImage: "",
                                        address: event.data()["address"] as? String ?? "",
                                        lat: event.data()["lat"] as? Double ?? 0.00,
                                        lon: event.data()["lon"] as? Double ?? 0.00,
                                        radius: event.data()["radius"] as? Double ?? 0.00,
                                        distanceFromUser: 0.0,
                                        tags: event.data()["tags"] as? [String] ?? [],
                                        startDate: event.data()["startDate"] as? String ?? formattedDate,
                                        endDate: event.data()["endDate"] as? String ?? formattedDate,
                                        startTime: event.data()["startTime"] as? String ?? "",
                                        endTime: event.data()["endTime"] as? String ?? "",
                                        published: event.data()["published"] as? Bool ?? true,
                                        hasMessageBoard: event.data()["published"] as? Bool ?? false,
                                        messageBoardPassword: event.data()["messageBoardPassword"] as? String ?? "",
                                        author: event.data()["author"] as? String ?? "",
                                        authorImagePath: event.data()["authorImagePath"] as? String ?? "",
                                        verified: event.data()["verified"] as? Bool ?? true,
                                        promoted: event.data()["promoted"] as? Bool ?? false,
                                        views: event.data()["views"] as? Int ?? 0,
                                        event18: event.data()["event18"] as? Bool ?? true,
                                        event21: event.data()["event21"] as? Bool ?? true,
                                        explicit: event.data()["explicit"] as? Bool ?? false,
                                        attendanceRecordID: event.data()["attendanceRecordID"] as? String ?? "",
                                        spotsAvailable: event.data()["spotsAvailable"] as? Int ?? 0,
                                        reservePrice: event.data()["radius"] as? Double ?? 0.00,
                                        website: event.data()["website"] as? String ?? "",
                                        fbSite: event.data()["fbSite"] as? String ?? "",
                                        twitterSite: event.data()["twitterSite"] as? String ?? "")
                                    let eventDate = Date(fromString: interestedEvent.startDate, format: .webblenFormat)
                                    
                                    if eventDate!.compare(.isInThePast) {
                                        let imagePath = interestedEvent.eventKey + ".jpg"
                                        self.imageStorage.child(imagePath).delete { error in
                                            if let error = error {}
                                        }
                                        self.database.collection("eventposts").document(interestedEvent.eventKey).delete()
                                    } else if eventDate!.compare(.isToday) {
                                        //print("eventToday")
                                        self.todayArray.append(interestedEvent)
                                        self.webblenEvents.append(interestedEvent)
                                    } else if eventDate!.compare(.isTomorrow) {
                                       //print("eventTomorrow")
                                        self.tomorrowArray.append(interestedEvent)
                                    } else if eventDate!.compare(.isThisWeek) {
                                        //print("eventThisWeek")
                                        self.thisWeekArray.append(interestedEvent)
                                    } else if eventDate!.compare(.isNextWeek) {
                                       // print("eventNextWeek")
                                        self.nextWeekArray.append(interestedEvent)
                                    } else if eventDate!.compare(.isThisMonth) {
                                        //print("eventThisMonth")
                                        self.thisMonthArray.append(interestedEvent)
                                    } else {
                                       // print("eventLater")
                                        self.laterArray.append(interestedEvent)
                                    }
                                
                            }
                            self.loadingView.stopAnimating()
                            self.eventTableView.reloadData()
                            self.checkForEvents()
                        }
                    })
                }
            }
        })
    }
    
    func locationAccessCheck(){
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showBlurAlert(title: "Not Able to Retrieve Your Location", message: "It looks like this device has location services disabled. Please enable them to be notified about events around you")
                loadingView.stopAnimating()
//                locationDisabledLbl.isHidden = false
//                refreshBtn.isEnabled = true
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
                if myEvents {
                    loadPersonalEvents()
                } else {
                    loadEventData(userLat: (locationManager.location?.coordinate.latitude)!, userLon: (locationManager.location?.coordinate.longitude)!, withinDistance: 35)
                }
            }
        }
    }

    
    //COLLECTION DATE VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarSelectCollectionView.dequeueReusableCell(withReuseIdentifier: "dateOptionCell", for: indexPath)
        let option = calendarOptions[indexPath.item]
        let background = cell.viewWithTag(1) as! UIViewX
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        if (indexPath.row == 0 && initialLoad){
            initialLoad = false
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.left)
            background.backgroundColor = activeBtnColor
            dateLabel.textColor = .darkGray
        }
        dateLabel.text = option
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = calendarSelectCollectionView.cellForItem(at: indexPath) {
            let background = cell.viewWithTag(1) as! UIViewX
            let dateLabel = cell.viewWithTag(2) as! UILabel
            background.backgroundColor = activeBtnColor
            dateLabel.textColor = .darkGray
        }
        let option = calendarOptions[indexPath.item]
        selectedCalendarOption = option
        if option == "Today" {
            webblenEvents = todayArray
        } else if option == "Tomorrow" {
            webblenEvents = tomorrowArray
        } else if option == "This Week" {
            webblenEvents = thisWeekArray
        } else if option == "Next Week" {
            webblenEvents = nextWeekArray
        } else if option == "This Month" {
            webblenEvents = thisMonthArray
        } else {
            webblenEvents = laterArray
        }
        
        eventTableView.reloadData()
        checkForEvents()
    }
    

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = calendarSelectCollectionView.cellForItem(at: indexPath) else {return}
        let background = cell.viewWithTag(1) as! UIViewX
        let dateLabel = cell.viewWithTag(2) as! UILabel
        background.backgroundColor = inactiveBtnColor
        dateLabel.textColor = .white
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for cell in calendarSelectCollectionView.visibleCells {
            let date = cell.viewWithTag(2) as! UILabel
            if date.text! != selectedCalendarOption {
                cell.isSelected = false
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //EVENTS TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.webblenEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let eventImageURL = self.webblenEvents[indexPath.row].pathToImage
        let eventAuthor = "@" + self.webblenEvents[indexPath.row].author
        let eventAuthorImageURL = self.webblenEvents[indexPath.row].authorImagePath
        let eventTitle = self.webblenEvents[indexPath.row].title
        let eventCaption = self.webblenEvents[indexPath.row].caption
        let eventTags = self.webblenEvents[indexPath.row].tags
        
        if eventImageURL.isEmpty {
            cell = self.eventTableView.dequeueReusableCell(withIdentifier: "defaultEventCell")!
            let eventAuthorImageView = cell.viewWithTag(1) as! UIImageViewX
            let eventTitleLbl = cell.viewWithTag(2) as! UILabel
            let eventAuthorName = cell.viewWithTag(3) as! UILabel
            let eventCaptionText = cell.viewWithTag(4) as! UILabel
            let authorURL = NSURL(string: eventAuthorImageURL)
            //Set Hero
            eventAuthorImageView.hero.id = "eventAuthorImage"
            eventTitleLbl.hero.id = "eventTitle"
            eventAuthorName.hero.id = "eventAuthorName"
            eventCaptionText.hero.id = "eventCaption"
            //Set Views
            eventAuthorImageView.sd_addActivityIndicator()
            eventAuthorImageView.sd_setShowActivityIndicatorView(true)
            eventAuthorImageView.sd_setIndicatorStyle(.gray)
            eventAuthorImageView.sd_setImage(with: authorURL! as URL, placeholderImage: nil)
            eventTitleLbl.text = eventTitle
            eventAuthorName.text = eventAuthor
            eventCaptionText.text = eventCaption
            
        } else {
            cell = self.eventTableView.dequeueReusableCell(withIdentifier: "eventWithImageCell")!
            let eventAuthorImageView = cell.viewWithTag(1) as! UIImageViewX
            let eventTitleLbl = cell.viewWithTag(2) as! UILabel
            let eventAuthorName = cell.viewWithTag(3) as! UILabel
            let eventCaptionText = cell.viewWithTag(4) as! UILabel
            let eventImageView = cell.viewWithTag(5) as! UIImageViewX
            let url = NSURL(string: eventImageURL)
            //Set Hero
            eventImageView.hero.id = "eventImageView"
            eventAuthorImageView.hero.id = "eventAuthorImage"
            eventTitleLbl.hero.id = "eventTitle"
            eventAuthorName.hero.id = "eventAuthorName"
            eventCaptionText.hero.id = "eventCaption"
            //Set Views
            eventImageView.sd_addActivityIndicator()
            eventImageView.sd_setShowActivityIndicatorView(true)
            eventImageView.sd_setIndicatorStyle(.gray)
            eventImageView.sd_setImage(with: url! as URL, placeholderImage: nil)
            let authorURL = NSURL(string: eventAuthorImageURL)
            eventAuthorImageView.sd_addActivityIndicator()
            eventAuthorImageView.sd_setShowActivityIndicatorView(true)
            eventAuthorImageView.sd_setIndicatorStyle(.gray)
            eventAuthorImageView.sd_setImage(with: authorURL! as URL, placeholderImage: nil)
            eventTitleLbl.text = eventTitle
            eventAuthorName.text = eventAuthor
            eventCaptionText.text = eventCaption
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventDetailsSegue", sender: webblenEvents[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EventDetailsSegue"){
            let eventIn = segue.destination as! EventDetailsViewController
            eventIn.event = sender as? EventPost
            if myEvents {
                eventIn.myEvents = true
            }
        }
    }
    
    func checkForEvents(){
        if webblenEvents.count < 1 {
            self.eventTableView.isHidden = true
        } else {
            self.eventTableView.isHidden = false
        }
        if myEvents {
            self.noEventImg.image = UIImage(named: "sad1")
            self.noEventLabel.text = "You Have No Events Set for This Time"
        } else {
            if selectedCalendarOption == "Today" {
                self.noEventImg.image = UIImage(named: "sad1")
                self.noEventLabel.text = "Shoot! It Doesn't Look Like Anything is Happening Today..."
            } else if selectedCalendarOption == "Tomorrow" {
                self.noEventImg.image = UIImage(named: "sad2")
                self.noEventLabel.text = "Sorry, There isn't Much Going On Tomorrow..."
            } else if selectedCalendarOption == "This Week" {
                self.noEventImg.image = UIImage(named: "sad3")
                self.noEventLabel.text = "How is There Nothing Happening This Week?"
            } else if selectedCalendarOption == "Next Week" {
                self.noEventImg.image = UIImage(named: "sad4")
                self.noEventLabel.text = "This Next Week is Looking Uneventful"
            } else if selectedCalendarOption == "This Month" {
                self.noEventImg.image = UIImage(named: "sad5")
                self.noEventLabel.text = "This Month is Dry"
            } else {
                self.noEventImg.image = UIImage(named: "sad5")
                self.noEventLabel.text = "Wow, This Place is Dead!"
            }
        }
    }
}
