//
//  GeotificationsViewController.swift
//  WebblenEvents
//
//  Created by Aditya Bhasin on 10/20/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps
import Firebase
import CoreLocation

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

class GeotificationsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var menuView: UIViewX!
    @IBOutlet weak var floatinActionButton: FloatingActionButton!
    
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    @IBOutlet weak var todayMenuOption: UIButton!
    @IBOutlet weak var tomorrowMenuOption: UIButton!
    @IBOutlet weak var weekMenuOption: UIButton!
    @IBOutlet weak var monthMenuOption: UIButton!
    @IBOutlet weak var laterMenuOption: UIButton!
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    //Geotification & Menu Variables

    var coordinates: [CLLocationCoordinate2D] = []
    var geotifications: [Geotification] = []
    var locationManager = CLLocationManager()
    var menuOpen = false
    var locationInfo = LocationTracking()
    var menuMarker = UIImage(named: "map-marker")?.withRenderingMode(.alwaysTemplate)


    //Database Variables
    var database = Firestore.firestore()
    var eventArray = [webblenEvent]()

    
    //Event Organzation
    var events = [Event]()
    var eventsToday = [Event]()
    var eventsThisWeek = [Event]()
    var eventsThisMonth = [Event]()
    var modifiedDescription = ""
    var eventCategory = "AMUSEMENT"
    
    var today : Bool?
    var thisWeek : Bool?
    var thisMonth : Bool?
    
    var currentDate = Date()
    var formatter = DateFormatter()
    
    //User Interests & Blocks
    var userInterests = ["none"]
    var userBlocks = ["key"]
    var interestHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Database
        let eventDummy = webblenEvent(title: "title", address: "4248 47th Ave, S", categories: ["ART", "MUSIC", "PARTYDANCE"], date: "01/01/2018", description: "Event Description", eventKey: "eventKey", lat: 46.810293, lon: -96.854455, paid: true, pathToImage: "", radius: 200, time: "2:00PM - 5:00PM", author: "Webblen Admin", verified: true, views: 0, event18: false, event21: false)
        var ref:DocumentReference? = nil
        ref = database.collection("events").addDocument(data: eventDummy.dictionary) {
            error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("success")
            }
        }
*/
        
        //Date Format
        formatter.dateFormat = "MM/dd/yyyy"

        //***UI
        //Reveal View Controller
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        //Map Marker Colors
        todayMenuOption.setImage(menuMarker, for: .normal)
        todayMenuOption.tintColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1.0)
        tomorrowMenuOption.setImage(menuMarker, for: .normal)
        tomorrowMenuOption.tintColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 1.0)
        weekMenuOption.setImage(menuMarker, for: .normal)
        weekMenuOption.tintColor = UIColor(red: 255/255, green: 238/255, blue: 88/255, alpha: 1.0)
        monthMenuOption.setImage(menuMarker, for: .normal)
        monthMenuOption.tintColor = UIColor(red: 102/255, green: 187/255, blue: 106/255, alpha: 1.0)
        laterMenuOption.setImage(menuMarker, for: .normal)
        laterMenuOption.tintColor = UIColor(red: 66/255, green: 165/255, blue: 245/255, alpha: 1.0)
        
        menuView.isHidden = true
        
        //Floating Action Button
        let floatingButton = UIImage(named: "plus-circle")?.withRenderingMode(.alwaysTemplate)
        floatinActionButton.setImage(floatingButton, for: .normal)
        floatinActionButton.tintColor = UIColor.darkGray
        //***
        
        //***Location Managing
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
        loadEvents()
        placeMarkers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func initGoogleMaps(){
        //Set camera
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.googleMapsView.camera = camera
        
        self.googleMapsView.delegate = self
        self.googleMapsView.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true
        
        
        //Create marker in the center of the map
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

    func gatherUserData(){
        //Gather user interests
    }
    
    
    //Load All Events
    func loadEvents(){
        database.collection("events").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.eventArray = querySnapshot!.documents.flatMap( {webblenEvent(dictionary: $0.data())} )
                DispatchQueue.main.async {
                }
            }
        }
    }
    
    func checkForUpdates(){
        
    }
    
    func placeMarkers(){
        let position = CLLocationCoordinate2D(latitude: 46.810293, longitude: -96.854455)
        let marker = GMSMarker(position: position)
        marker.title = "Event Title"
        marker.snippet = "Description"
        marker.map = googleMapsView
    }
    
    // Mark: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manger: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.googleMapsView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
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





