//
//  NewEventSearchAddressViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/30/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class NewEventSearchAddressViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {

    //Address Variables
    var locationManager = CLLocationManager()
    var chosenAddress: String?
    var placeName: String?
    var lat: Double?
    var lon: Double?
    var radiusInMeters = 250.0
    var miles = 0.15
    var notifIncrement = Float(0.05)
    var isValid = false
    var eventsFree = true
    
    //UI
    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var notifyLbl: UILabel!
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var eventTotalLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        googleMapsView.alpha = 0
        googleMapsView.isUserInteractionEnabled = false
        distanceSlider.isEnabled = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()

    }

    
    @IBAction func didPressSearchAddress(_ sender: Any) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.country = "US"
        autoCompleteController.autocompleteFilter = filter
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func sliderValChanged(_ sender: UISlider) {
        let camera = GMSCameraPosition.camera(withLatitude: self.lat!, longitude: self.lon!, zoom: 11.0)
        self.googleMapsView.animate(to: camera)
        //Increments of .15
        let roundedValue = round(sender.value / notifIncrement) * notifIncrement
        sender.value = roundedValue
        notifyLbl.text = "Notify Users within " + String(roundedValue) + " Miles"
        
        googleMapsView.clear()
        //Create Marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.lon!)
        marker.map = googleMapsView
        
        self.radiusInMeters = Double(roundedValue * 1609.34)
        print(self.radiusInMeters)
        setPriceLabel(val: self.radiusInMeters)
        //var currentValue = Int(sender.value)
        let circleCenter = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.lon!)
        let circ = GMSCircle(position: circleCenter, radius: radiusInMeters)
        circ.fillColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 0.4)
        circ.strokeColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 0.5)
        circ.map = googleMapsView
    }
    
    
    @IBAction func didPressNext(_ sender: Any) {
        proceedToPurchase()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmEventSegue"){
            let eventIn = segue.destination as! NewEventConfirmViewController
            eventIn.newEvent = sender as? EventPost
        }
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
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.googleMapsView.alpha = 1.0 // Here you will get the animation you want
        }, completion: { _ in
            self.googleMapsView.isUserInteractionEnabled = true
        })
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
        if (gesture) { mapView.selectedMarker = nil }
    }
    
    // Mark: Google auto complete delegate
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 12.0)
        
        //Create Marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.name
        marker.map = googleMapsView
        
        let circleCenter = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let circ = GMSCircle(position: circleCenter, radius: 250)
        circ.fillColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 0.4)
        circ.strokeColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 0.5)
        circ.map = googleMapsView
        self.googleMapsView.camera = camera
        
        placeName = place.name
        chosenAddress = place.formattedAddress!
        convertAddressToLatAndLong(eventAddress: chosenAddress!)
        addressLbl.text = chosenAddress!
        isValid = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print ("Error auto complete \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Convert address from String to Coordinates
    func convertAddressToLatAndLong(eventAddress: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(eventAddress) {
            placemarks, error in
            let placemark = placemarks?.first
            self.lat = (placemark?.location?.coordinate.latitude)!
            self.lon = (placemark?.location?.coordinate.longitude)!
        }
        distanceSlider.isEnabled = true
    }
    
    func proceedToPurchase(){
        if isValid {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.newEvent.address = chosenAddress!
                    parentVC.newEvent.radius = radiusInMeters
                    parentVC.newEvent.lat = lat!
                    parentVC.newEvent.lon = lon!
                    performSegue(withIdentifier: "confirmEventSegue", sender: parentVC.newEvent)
                }
            }
        } else {
            showBlurAlert(title: "Address Missing", message: "Please Set the Address for This Event")
        }
    }
    
    //Swipe Actions
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if let parentVC = self.parent {
                if let parentVC = parentVC as? NewEventPagingViewController {
                    parentVC.displayPageForIndex(index: 5)
                }
            }
        }
    }
    
    func setPriceLabel(val: Double){
        if eventsFree {
            eventTotalLbl.text = "Total: FREE"
        } else if val < 275 {
            eventTotalLbl.text = "Total: $2.99"
        } else if val < 400 {
            eventTotalLbl.text = "Total: $4.99"
        } else if val < 600 {
            eventTotalLbl.text = "Total: $9.99"
        } else if val < 1000 {
            eventTotalLbl.text = "Total: $14.99"
        } else if val < 2000 {
            eventTotalLbl.text = "Total: $19.99"
        } else if val < 3100 {
            eventTotalLbl.text = "Total: $24.99"
        } else if val < 6000 {
            eventTotalLbl.text = "Total: $26.99"
        } else if val < 8500 {
            eventTotalLbl.text = "Total: $29.99"
        } else {
            eventTotalLbl.text = "Total: $34.99"
        }
    }

}
