//
//  GeotificationsViewController.swift
//  Webblen
//
//  Created by Mukai Selekwa on 10/20/17.
//  Copyright © 2018 Webblen. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import CoreLocation
import UserNotifications
import NVActivityIndicatorView

class GeotificationsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var menuView: UIViewX!
    @IBOutlet weak var floatinActionButton: FloatingActionButton!
    
    @IBOutlet weak var refreshButton: FloatingActionButton!
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    @IBOutlet weak var todayMenuOption: UIButton!
    @IBOutlet weak var tomorrowMenuOption: UIButton!
    @IBOutlet weak var weekMenuOption: UIButton!
    @IBOutlet weak var monthMenuOption: UIButton!
    @IBOutlet weak var laterMenuOption: UIButton!
    
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet var panGestureMenu: UIScreenEdgePanGestureRecognizer!
    
    
    static let activityData = ActivityData()
    var activityIndicator : NVActivityIndicatorView!
    
    //Geotification & Menu Variables
    var initialLoad = false
    var coordinates: [CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    var menuOpen = false
    var locationInfo = LocationTracking()
    var menuMarker = UIImage(named: "map-marker")?.withRenderingMode(.alwaysTemplate)


    //Database Variables
    var database = Firestore.firestore()
    var todayArray = [webblenEvent]()
    var tomorrowArray = [webblenEvent]()
    var thisWeekArray = [webblenEvent]()
    var thisMonthArray = [webblenEvent]()
    var laterArray = [webblenEvent]()
    
    //Event Organzation
    var events = [webblenEvent]()
    var modifiedDescription = ""
    var eventCategory = "AMUSEMENT"
    
    var monitoredRegions:[CLCircularRegion] = []
    var currentRegion : String?
    
    var closestEventKey: String?
    var closestEventTitle: String?
    var closestEventIsHidden = false
    var requestTrigger = UNTimeIntervalNotificationTrigger(timeInterval: (60*60*12*2), repeats: true)
    
    var formatter = DateFormatter()
    var dateCalendar = Calendar.current
    var distanceFromEvent = 10000.0
    
    //User Interests & Blocks
    var currentUser = Auth.auth().currentUser
    var userInterests = [""]
    var userBlocks = [""]
    var interestHandle: DatabaseHandle?
    
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .ballRotateChase, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        googleMapsView.isUserInteractionEnabled = false
        googleMapsView.alpha = 0
        
        refreshButton.isUserInteractionEnabled = false
        
        //Date Format
        formatter.dateFormat = "MM/dd/yyyy"
        //***UI
        //Reveal View Controller
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis-147), y: (yAxis-135), width: 300, height: 300)
        loadingView = NVActivityIndicatorView(frame: frame, type: .ballScaleMultiple, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 0.5), padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        //Map Marker Colors
        todayMenuOption.setImage(menuMarker, for: .normal)
        todayMenuOption.tintColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1.0)
        tomorrowMenuOption.setImage(menuMarker, for: .normal)
        tomorrowMenuOption.tintColor = UIColor(red: 240/255, green: 98/255, blue: 146/255, alpha: 1.0)
        weekMenuOption.setImage(menuMarker, for: .normal)
        weekMenuOption.tintColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 1.0)
        monthMenuOption.setImage(menuMarker, for: .normal)
        monthMenuOption.tintColor = UIColor(red: 102/255, green: 187/255, blue: 106/255, alpha: 1.0)
        laterMenuOption.setImage(menuMarker, for: .normal)
        laterMenuOption.tintColor = UIColor(red: 66/255, green: 165/255, blue: 245/255, alpha: 1.0)
        
        menuView.isHidden = true
        
        //Floating Action Buttons
        let floatingButton = UIImage(named: "plus-circle")?.withRenderingMode(.alwaysTemplate)
        floatinActionButton.setImage(floatingButton, for: .normal)
        floatinActionButton.tintColor = UIColor.darkGray
        let refreshIcon = UIImage(named: "reload")?.withRenderingMode(.alwaysTemplate)
        refreshButton.setImage(refreshIcon, for: .normal)
        refreshButton.tintColor = UIColor.darkGray
        
        
        //***Location Managing
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        

        initGoogleMaps()
        if (currentUser == nil){
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showAlert(withTitle: "Not Able to Retrieve Your Location", message: "It looks like this device has location services disabled. Please enable them to be notified about events around you")
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
                loadEventData()
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadEventData(){
        self.refreshButton.isUserInteractionEnabled = false
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
                                    
                                    //Get teh coordinates of the closest evetn
                                    let eventCoordinates = CLLocation(latitude: interestedEvent.lat, longitude: interestedEvent.lon)
                                    let currentCoordinates = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                                    self.distanceFromEvent = currentCoordinates.distance(from: eventCoordinates)
                                    if interestedEvent.distanceFromUser < self.distanceFromEvent {
                                        interestedEvent.distanceFromUser = self.distanceFromEvent
                                        self.currentRegion = interestedEvent.eventKey
                                        self.closestEventTitle = interestedEvent.title
                                        self.closestEventKey = interestedEvent.eventKey
                                        if interestedEvent.notificationOnly == true {
                                            self.closestEventIsHidden = true
                                        }
                                        else {
                                            self.closestEventIsHidden = false
                                        }
                                    }
                
                                            //Append to Event Date Arrays
                                            if (eventDate! < currentDate! && interestedEvent.paid) {
                                                self.database.collection("events").document(interestedEvent.eventKey).delete()
                                            }
                                            else if (currentDate! == eventDate! && interestedEvent.paid) {
                                                if (self.userBlocks.contains(interestedEvent.author)) == false{
                                                self.todayArray.append(interestedEvent)
                                                }
                                            }
                                            else if (daysBetweenEvents.day! == 1 && interestedEvent.paid) {
                                                if (self.userBlocks.contains(interestedEvent.author)) == false{
                                                self.tomorrowArray.append(interestedEvent)
                                                }
                                            }
                                            else if (daysBetweenEvents.day! > 1 && daysBetweenEvents.day! < 8 && interestedEvent.paid) {
                                                if (self.userBlocks.contains(interestedEvent.author)) == false{

                                                self.thisWeekArray.append(interestedEvent)
                                                }
                                            }
                                            else if (daysBetweenEvents.day! >= 8 && daysBetweenEvents.day! <= 31 && interestedEvent.paid) {
                                                if (self.userBlocks.contains(interestedEvent.author)) == false{
                                                self.thisMonthArray.append(interestedEvent)
                                                }
                                            }
                                            else {
                                                if ((self.userBlocks.contains(interestedEvent.author)) == false) && interestedEvent.paid{
                                                self.laterArray.append(interestedEvent)
                                                }
                                            }
                                        
                                    
                                }
                                
                                //Place Markers and Set Regions for Today's Events
                                if self.todayArray.count > 0 {
                                    for e in self.todayArray {
                                        if e.distanceFromUser <= 10000 {
                                            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
                                            let marker = GMSMarker(position: position)
                                            marker.title = e.eventKey
                                            marker.icon = GMSMarker.markerImage(with: nil)
                                            marker.icon = GMSMarker.markerImage(with: UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1.0))
                                            marker.map = self.googleMapsView
                                           
                                            let randomRegion = Int.random(min: 250, max: Int(e.radius))
                                            
                                            let region = CLCircularRegion(center: position, radius: Double(randomRegion), identifier: e.eventKey)
                                            region.notifyOnEntry = true
                                            region.notifyOnExit = false
                                            self.locationManager.startMonitoring(for: region)
                                        }
                                    }
                                }
                                if self.tomorrowArray.count > 0 {
                                    for e in self.tomorrowArray {
                                        if e.distanceFromUser <= 10000 {
                                            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
                                            let randomRegion = Int.random(min: 250, max: Int(e.radius))
                                            let region = CLCircularRegion(center: position, radius: Double(randomRegion), identifier: e.eventKey)
                                            region.notifyOnEntry = true
                                            region.notifyOnExit = false
                                            self.locationManager.startMonitoring(for: region)
                                        }
                                    }
                                }
                                if self.thisWeekArray.count > 0 {
                                    for e in self.thisWeekArray {
                                        if e.distanceFromUser <= 10000 {
                                            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
                                            let randomRegion = Int.random(min: 250, max: Int(e.radius))
                                            let region = CLCircularRegion(center: position, radius: Double(randomRegion), identifier: e.eventKey)
                                            region.notifyOnEntry = true
                                            region.notifyOnExit = false
                                            self.locationManager.startMonitoring(for: region)
                                        }
                                    }
                                }
                                if self.thisMonthArray.count > 0 {
                                    for e in self.thisMonthArray {
                                        if e.distanceFromUser <= 10000 {
                                            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
                                            let randomRegion = Int.random(min: 250, max: Int(e.radius))
                                            let region = CLCircularRegion(center: position, radius: Double(randomRegion), identifier: e.eventKey)
                                            region.notifyOnEntry = true
                                            region.notifyOnExit = false
                                            self.locationManager.startMonitoring(for: region)
                                        }
                                    }
                                }
                                //Loading Animations and check for closest regions
                                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                                    self.googleMapsView.alpha = 1.0
                                }, completion: { _ in
                                    self.googleMapsView.isUserInteractionEnabled = true
                                    self.refreshButton.isUserInteractionEnabled = true
                                })
                                self.checkAndMonitorTwentyClosestRegions()
                                self.loadingView.stopAnimating()
                                }
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
    
    func initGoogleMaps(){
        //Set camera
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.googleMapsView.camera = camera
        //Show current location
        self.googleMapsView.delegate = self
        self.googleMapsView.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true
    }

    // Mark: GMSMapview Delegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
        self.googleMapsView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        performSegue(withIdentifier: "eventInfoSegue", sender: marker.title!)
        return true
    }
    
    // Mark: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manger: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12.0)
        
        self.googleMapsView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    //Actions Performed When Entering Region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if let e = self.todayArray.index(where: { $0.eventKey == region.identifier }) {
            let selectedEvent = self.todayArray[e]
            let eventTitleString = selectedEvent.title
            if selectedEvent.notificationOnly == true {
                showEventAlert(withTitle: "You found a Hidden Event for Today Nearby!", message: "Would you like to see more information about the event: \"" + eventTitleString + "\"?", region: region.identifier)
                self.showNotification(title: "Hidden Event Found!", message: "You've Come Accross a Secret Event. Check it out!")
            }
            else {
            showEventAlert(withTitle: "There's Something You May be Interested in Happening Today!", message: "Would you like to see more information about the event: \"" + eventTitleString + "\"?", region: region.identifier)
            self.showNotification(title: selectedEvent.author + " has an event today!", message: "The Event: " + eventTitleString + " is happening today. Check it out!")
            }
        }
        if let e = self.tomorrowArray.index(where: { $0.eventKey == region.identifier }) {
            let selectedEvent = self.tomorrowArray[e]
            let eventTitleString = selectedEvent.title
            currentRegion = region.identifier
            if selectedEvent.notificationOnly == true {
                showEventAlert(withTitle: "You found a Hidden Event for Tomorrow!", message: "Would you like to see more information about the event: \"" + eventTitleString + "\"?", region: region.identifier)
                self.showNotification(title: "Hidden Event Found!", message: "You've Come Accross a Secret Event. Check it out!")
            }
            else{
            showEventAlert(withTitle: "An Event You May be Interested in Will Occur Tomorrow Nearby!", message: "Would you like to see more information about the event: \"" + eventTitleString + "\"?", region: region.identifier)
            self.showNotification(title: selectedEvent.author + " has an event tommorow!", message: "The Event: " + eventTitleString + " is happening tomorrow. Check it out!")
            }
        }
        if let e = self.thisWeekArray.index(where: { $0.eventKey == region.identifier }) {
            let selectedEvent = self.thisWeekArray[e]
            let eventTitleString = selectedEvent.title
            if selectedEvent.notificationOnly == true {
                showEventAlert(withTitle: "You found a Hidden Event for This Week Nearby!", message: "Would you like to see more information about the event: \"" + eventTitleString + "\"?", region: region.identifier)
                self.showNotification(title: "Hidden Event Found!", message: "You've Come Accross a Secret Event. Check it out!")
            }
            else{
            showEventAlert(withTitle: "An Event You'd Be Interested in Will Occur in the Next Few Days Nearby!", message: "Would you like to see more information about the event: \"" + eventTitleString + "\"?", region: region.identifier)
            self.showNotification(title: selectedEvent.author + " has an event this week", message: eventTitleString + " is happening this week. Check it out!")
            }
        }
        if let e = self.thisMonthArray.index(where: { $0.eventKey == region.identifier }) {
            let selectedEvent = self.thisMonthArray[e]
            let eventTitleString = selectedEvent.title
            if selectedEvent.notificationOnly == true {
                showEventAlert(withTitle: "You found a Hidden Event for This Month!", message: "Would you like to see more information about the event: \"" + eventTitleString + "\"?", region: region.identifier)
                self.showNotification(title: "Hidden Event Found!", message: "You've Come Accross a Secret Event. Check it out!")
            }
            else{
            showEventAlert(withTitle: "An Event You'd Be Interested in Will Occur Next Few Weeks Nearby!", message: "Would you like to see more information about the event: \"" + eventTitleString + "\"?", region: region.identifier)
            self.showNotification(title: selectedEvent.author + " has an event later!", message: "The Event: " + eventTitleString + " is happening this month. Check it out!")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    }
    
    func checkAndMonitorTwentyClosestRegions(){
        
        stopMonitoringAllRegions()
        
        if monitoredRegions.count > 20  {
            print("orderRegions")
            var sortableRegions:[SortableRegion] = []
            let currentlocation = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            
                for region in self.monitoredRegions {
                let regionLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
                let distance = currentlocation.distance(from: regionLocation)
                
                let sortRegion = SortableRegion(distance: distance, region: region)
                    //if !(sortableRegions.map{$0.region}).contains(sortRegion.region) {
                        sortableRegions.append(sortRegion)
                    //    print("added region)
                    //}
                    //else {
                    //    print("no duplicate regions")
                    //}
            }
            
            let sortedArray = sortableRegions.sorted {
                $0.distance < $1.distance
            }
            
            // Grab the first 20 closest and monitor those.
            
            let firstTwentyRegions = sortedArray[0..<20]
            for item in firstTwentyRegions {
                let region = item.region
                locationManager.startMonitoring(for: region)
            }
        }
        else {
            //If there are less than 20, monitor all
            print("monitor all regions")
            for region in monitoredRegions {
            locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func stopMonitoringAllRegions(){
        for monitored in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: monitored)
        }
    }
    
    func showEventAlert(withTitle title: String?, message: String?, region: String?) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let yesOption = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.loadingView.stopAnimating()
            self.performSegue(withIdentifier: "eventInfoSegue", sender: region)
        })
        let dismissAction = UIAlertAction(title: "No Thanks", style: .cancel, handler: { action in
            self.loadingView.stopAnimating()
        })
        alert.addAction(yesOption)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "notif", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //Function called when clicking on an event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventInfoSegue"){
            let eventIn = segue.destination as! EventInfoViewController
            eventIn.eventKey = sender as! String
        }
    }
    
    
    @IBAction func didPressRefresh(_ sender: Any) {
        self.loadingView.startAnimating()
        self.menuOpen = true
        self.menuView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.googleMapsView.alpha = 0
            self.googleMapsView.clear()
        }, completion: { _ in
            self.googleMapsView.isUserInteractionEnabled = false
            
        })
        self.todayArray.removeAll()
        self.tomorrowArray.removeAll()
        self.thisWeekArray.removeAll()
        self.thisMonthArray.removeAll()
        self.loadEventData()
    }
    
    @IBAction func didPressToday(_ sender: Any) {
        googleMapsView.clear()
        self.loadingView.startAnimating()
        var eventLat = 0.0
        var eventLon = 0.0
        self.distanceFromEvent = 10000.0
        for e in self.todayArray {
            if e.notificationOnly == false {
            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
            let eventLocation = CLLocation(latitude: e.lat, longitude: e.lon)
            let currentCoordinates = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let calculatedDistance = currentCoordinates.distance(from: eventLocation)
                if calculatedDistance <= self.distanceFromEvent {
                    self.distanceFromEvent = calculatedDistance
                    eventLat = e.lat
                    eventLon = e.lon
                }
            let marker = GMSMarker(position: position)
            marker.title = e.eventKey
            marker.icon = GMSMarker.markerImage(with: nil)
            marker.icon = GMSMarker.markerImage(with: UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 0.7))
            marker.map = self.googleMapsView
            }
        }
        if self.todayArray.count < 1 {
            self.showAlert(withTitle: "No events found", message: "Sorry, it looks like there's nothing you'd be interested in happening today.")
        }
        else {
            let camera = GMSCameraPosition.camera(withLatitude: eventLat, longitude: eventLon, zoom: 12.0)
            self.googleMapsView.camera = camera
        }
        self.loadingView.stopAnimating()
    }
    
    @IBAction func didPressTomorrow(_ sender: Any) {
        googleMapsView.clear()
        self.loadingView.startAnimating()
        var eventLat = 0.0
        var eventLon = 0.0
        self.distanceFromEvent = 10000.0
        for e in self.tomorrowArray {
            if e.notificationOnly == false {
            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
            let eventLocation = CLLocation(latitude: e.lat, longitude: e.lon)
            let currentCoordinates = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let calculatedDistance = currentCoordinates.distance(from: eventLocation)
                if calculatedDistance <= self.distanceFromEvent {
                    self.distanceFromEvent = calculatedDistance
                    eventLat = e.lat
                    eventLon = e.lon
                }
            let marker = GMSMarker(position: position)
            marker.title = e.eventKey
            marker.icon = GMSMarker.markerImage(with: nil)
            marker.icon = GMSMarker.markerImage(with: UIColor(red: 240/255, green: 98/255, blue: 146/255, alpha: 1.0))
            marker.map = self.googleMapsView
            }
        }
        if self.tomorrowArray.count < 1 {
            self.showAlert(withTitle: "No events found", message: "Sorry, it looks like there's nothing you'd be interested in happening tomorrow.")
        }
        else {
            let camera = GMSCameraPosition.camera(withLatitude: eventLat, longitude: eventLon, zoom: 12.0)
            self.googleMapsView.camera = camera
        }
        self.loadingView.stopAnimating()
    }
    @IBAction func didPressWeek(_ sender: Any) {
        googleMapsView.clear()
        self.loadingView.startAnimating()
        var eventLat = 0.0
        var eventLon = 0.0
        self.distanceFromEvent = 10000.0
        for e in self.thisWeekArray {
            if e.notificationOnly == false {
            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
            let eventLocation = CLLocation(latitude: e.lat, longitude: e.lon)
            let currentCoordinates = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let calculatedDistance = currentCoordinates.distance(from: eventLocation)
                if calculatedDistance <= self.distanceFromEvent {
                    self.distanceFromEvent = calculatedDistance
                    eventLat = e.lat
                    eventLon = e.lon
                }
            let marker = GMSMarker(position: position)
            marker.title = e.eventKey
            marker.icon = GMSMarker.markerImage(with: nil)
            marker.icon = GMSMarker.markerImage(with: UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 0.7))
            marker.map = self.googleMapsView
            }
        }
        if self.thisWeekArray.count < 1 {
            self.showAlert(withTitle: "No events found", message: "Sorry, it looks like there's nothing you'd be interested in happening later this week.")
        }
        else {
            let camera = GMSCameraPosition.camera(withLatitude: eventLat, longitude: eventLon, zoom: 12.0)
            self.googleMapsView.camera = camera
        }
        self.loadingView.stopAnimating()
    }
    @IBAction func didPressMonth(_ sender: Any) {
        googleMapsView.clear()
        self.loadingView.startAnimating()
        var eventLat = 0.0
        var eventLon = 0.0
        self.distanceFromEvent = 10000.0
        for e in self.thisMonthArray {
            if e.notificationOnly == false {
            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
            let eventLocation = CLLocation(latitude: e.lat, longitude: e.lon)
            let currentCoordinates = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let calculatedDistance = currentCoordinates.distance(from: eventLocation)
                if calculatedDistance <= self.distanceFromEvent {
                    self.distanceFromEvent = calculatedDistance
                    eventLat = e.lat
                    eventLon = e.lon
                }
            let marker = GMSMarker(position: position)
            marker.title = e.eventKey
            marker.icon = GMSMarker.markerImage(with: nil)
            marker.icon = GMSMarker.markerImage(with: UIColor(red: 102/255, green: 187/255, blue: 106/255, alpha: 1.0))
            marker.map = self.googleMapsView
            }
        }
        if self.thisMonthArray.count < 1 {
            self.showAlert(withTitle: "No events found", message: "Sorry, it looks like there's nothing you'd be interested in happening this month... How boring, right?")
        }
        else {
            let camera = GMSCameraPosition.camera(withLatitude: eventLat, longitude: eventLon, zoom: 12.0)
            self.googleMapsView.camera = camera
        }
        self.loadingView.stopAnimating()
    }
    
    @IBAction func didPressLater(_ sender: Any) {
        googleMapsView.clear()
        self.loadingView.startAnimating()
        var eventLat = 0.0
        var eventLon = 0.0
        self.distanceFromEvent = 10000.0
        for e in self.laterArray {
            if e.notificationOnly == false {
            let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
            let eventLocation = CLLocation(latitude: e.lat, longitude: e.lon)
            let currentCoordinates = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
            let calculatedDistance = currentCoordinates.distance(from: eventLocation)
            if calculatedDistance <= self.distanceFromEvent {
                    self.distanceFromEvent = calculatedDistance
                    eventLat = e.lat
                    eventLon = e.lon
                }
            let marker = GMSMarker(position: position)
            marker.title = e.eventKey
            marker.icon = GMSMarker.markerImage(with: nil)
            marker.icon = GMSMarker.markerImage(with: UIColor(red: 66/255, green: 165/255, blue: 245/255, alpha: 0.7))
            marker.map = self.googleMapsView
            }
        }
        if self.laterArray.count < 1 {
            self.showAlert(withTitle: "No events found", message: "Sorry, it looks like there's nothing you'd be interested in happening later. That's super unfortunate. You must be in the middle of nowhere or something..")
        }
        else {
            let camera = GMSCameraPosition.camera(withLatitude: eventLat, longitude: eventLon, zoom: 12.0)
            self.googleMapsView.camera = camera
        }
        self.loadingView.stopAnimating()
    }
    
    @IBAction func menuTap(_ sender: Any) {
        if menuOpen == true {
            UIView.transition(with: self.menuView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                self.menuView.isHidden = true
                }, completion: nil)
            menuOpen = false
            }
        else {
            UIView.transition(with: self.menuView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                self.menuView.isHidden = false
            }, completion: nil)
            menuOpen = true
        }
    }
    
    
}






