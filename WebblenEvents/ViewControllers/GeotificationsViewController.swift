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

let darkMap = "[" +
"{" +
"    \"stylers\": [" +
"    {" +
"        \"saturation\": -30" +
"    }," +
"    {" +
"        \"weight\": 2.5" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"administrative\"," +
"    \"elementType\": \"geometry\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"off\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"poi\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"off\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"poi.attraction\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"on\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"poi.business\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"on\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"poi.school\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"on\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"poi.sports_complex\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"on\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"road\"," +
"    \"elementType\": \"labels.icon\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"off\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"road.arterial\"," +
"    \"elementType\": \"labels\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"off\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"road.highway\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"simplified\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"road.highway\"," +
"    \"elementType\": \"geometry\"," +
"    \"stylers\": [" +
"    {" +
"        \"color\": \"#d5d5d5\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"road.highway\"," +
"    \"elementType\": \"labels\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"off\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"road.local\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"off\"" +
"    }" +
"    ]" +
"}," +
"{" +
"    \"featureType\": \"transit\"," +
"    \"stylers\": [" +
"    {" +
"        \"visibility\": \"off\"" +
"    }" +
"    ]" +
"}" +
"]"

class GeotificationsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate , UITabBarControllerDelegate {

    
    
    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    @IBOutlet weak var todayMenuOption: UIButton!
    @IBOutlet weak var tomorrowMenuOption: UIButton!
    @IBOutlet weak var weekMenuOption: UIButton!
    @IBOutlet weak var monthMenuOption: UIButton!
    @IBOutlet weak var laterMenuOption: UIButton!
    @IBOutlet weak var todayMenuLbl: UILabel!
    @IBOutlet weak var tomorrowMenuLbl: UILabel!
    @IBOutlet weak var thisWeekMenuLbl: UILabel!
    @IBOutlet weak var thisMonthMenuLbl: UILabel!
    @IBOutlet weak var laterMenuLbl: UILabel!
    
    @IBOutlet weak var locationDisabledLbl: UILabel!
    @IBOutlet weak var Open: UIBarButtonItem!
    @IBOutlet var panGestureMenu: UIScreenEdgePanGestureRecognizer!
    
    
    //Geotification & Menu Variables
    var coordinates: [CLLocationCoordinate2D] = []
    let locationManager = CLLocationManager()
    var menuMarker = UIImage(named: "map-marker")?.withRenderingMode(.alwaysTemplate)
    var markerIcon = UIImage(named: "customMapMarker")


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
    
    var formatter = DateFormatter()
    var dateCalendar = Calendar.current
    var distanceFromEvent = 10000.0
    
    //User Interests & Blocks
    var currentUser = Auth.auth().currentUser
    var userInterests = [""]
    var userBlocks = [""]
    
    //Extras
    var activeColor = UIColor(red: 30/300, green: 39/300, blue: 46/300, alpha: 1.0)
    var inactiveColor = UIColor(red: 178/300, green: 190/300, blue: 195/300, alpha: 1.0)
    var loadingView = NVActivityIndicatorView(frame: CGRect(x: (100), y: (100), width: 125, height: 125), type: .lineScale, color: UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1.0), padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMapsView.isUserInteractionEnabled = false
        googleMapsView.alpha = 0
        
        //Date Format
        formatter.dateFormat = "MM/dd/yyyy"
        //***UI
        //Reveal View Controller
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        var frame = CGRect(x: (xAxis-25), y: (yAxis-75), width: 50, height: 50)
        loadingView = NVActivityIndicatorView(frame: frame, type: .lineScale, color: UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0), padding: 0)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        //Menu Colors
        todayMenuOption.setImage(menuMarker, for: .normal)
        todayMenuOption.tintColor = activeColor
        todayMenuLbl.textColor = activeColor
        
        
        tomorrowMenuOption.setImage(menuMarker, for: .normal)
        tomorrowMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        tomorrowMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        weekMenuOption.setImage(menuMarker, for: .normal)
        weekMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisWeekMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        monthMenuOption.setImage(menuMarker, for: .normal)
        monthMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisMonthMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        laterMenuOption.setImage(menuMarker, for: .normal)
        laterMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        laterMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        
        
        //***Location Managing
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()


        initGoogleMaps()
        if (currentUser == nil){
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
        locationAccessCheck()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadEventData(){
        self.refreshBtn.isEnabled = false
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
                                            marker.icon = nil
                                            marker.icon = self.markerIcon
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
                                    self.refreshBtn.isEnabled = true
                                    
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
        do {
            // Set the map style by passing a valid JSON string.
            self.googleMapsView.mapStyle = try GMSMapStyle(jsonString: darkMap)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
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
    
    func locationAccessCheck(){
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showAlert(withTitle: "Not Able to Retrieve Your Location", message: "It looks like this device has location services disabled. Please enable them to be notified about events around you")
                loadingView.stopAnimating()
                locationDisabledLbl.isHidden = false
                refreshBtn.isEnabled = true
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
                loadEventData()
            }
        }
    }
    
    @IBAction func didRefresh(_ sender: Any) {
        locationDisabledLbl.isHidden = true
        self.loadingView.startAnimating()
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.refreshBtn.isEnabled = false
            self.googleMapsView.alpha = 0
            self.googleMapsView.clear()
        }, completion: { _ in
            self.googleMapsView.isUserInteractionEnabled = false
            
        })
        self.todayArray.removeAll()
        self.tomorrowArray.removeAll()
        self.thisWeekArray.removeAll()
        self.thisMonthArray.removeAll()
        locationAccessCheck()
    }
    
    @IBAction func didPressToday(_ sender: Any) {
        //Adjust Menu
        todayMenuOption.tintColor = activeColor
        todayMenuLbl.textColor = activeColor
        
        tomorrowMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        tomorrowMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        weekMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisWeekMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        monthMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisMonthMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        laterMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        laterMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        //Adjust Map
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
                marker.icon = nil
                marker.icon = self.markerIcon
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
        //Adjust Menu
        todayMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        todayMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        tomorrowMenuOption.tintColor = activeColor
        tomorrowMenuLbl.textColor = activeColor
        
        weekMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisWeekMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        monthMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisMonthMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        laterMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        laterMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        //Adjust Map
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
                marker.icon = nil
                marker.icon = self.markerIcon
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
        //Adjust Menu
        todayMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        todayMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        tomorrowMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        tomorrowMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        weekMenuOption.tintColor = activeColor
        thisWeekMenuLbl.textColor = activeColor
        
        monthMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisMonthMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        laterMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        laterMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        //Adjust Map
        googleMapsView.clear()
        self.loadingView.startAnimating()
        var eventLat = 0.0
        var eventLon = 0.0
        self.distanceFromEvent = 10000.0
        for e in self.thisWeekArray {
            if e.notificationOnly == false {
                let position = CLLocationCoordinate2D(latitude: e.lat, longitude: e.lon)
                let eventLocation = CLLocation(latitude: e.lat, longitude: e.lon)
                if self.locationManager.location != nil {
                    let currentCoordinates = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                    let calculatedDistance = currentCoordinates.distance(from: eventLocation)
                    if calculatedDistance <= self.distanceFromEvent {
                        self.distanceFromEvent = calculatedDistance
                        eventLat = e.lat
                        eventLon = e.lon
                    }
                }
                let marker = GMSMarker(position: position)
                marker.title = e.eventKey
                marker.icon = nil
                marker.icon = self.markerIcon
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
        //Adjust Menu
        todayMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        todayMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        tomorrowMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        tomorrowMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        weekMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisWeekMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        monthMenuOption.tintColor = activeColor
        thisMonthMenuLbl.textColor = activeColor
        
        laterMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        laterMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        //Adjust Map
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
                marker.icon = nil
                marker.icon = self.markerIcon
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
        //Adjust Menu
        todayMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        todayMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        tomorrowMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        tomorrowMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        weekMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisWeekMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        monthMenuOption.tintColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        thisMonthMenuLbl.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
        
        laterMenuOption.tintColor = activeColor
        laterMenuLbl.textColor = activeColor
        
        //Adjust Map
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
                marker.icon = nil
                marker.icon = self.markerIcon
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
}






