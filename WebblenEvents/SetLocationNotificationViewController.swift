//
//  SetLocationNotificationViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 10/28/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps


class SetLocationNotificationViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var searchAddressButton: UIBarButtonItem!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var notificationSlider: UISlider!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var notificationField: UITextField!
    

    
    //var geotifications = [Geotification]()
    var locationManager = CLLocationManager()
    var chosenAddress = ""
    var placeName = ""
    var lat = 46.8772
    var lon = -96.7898
    var radius = 250.0
    var notifIncrement = Float(25)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMapsView.alpha = 0
        googleMapsView.isUserInteractionEnabled = false
        
        notificationField.delegate = self
        
        notificationField.isEnabled = false
        notificationSlider.isEnabled = false
        setLocationButton.isEnabled = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if (gesture) {
            mapView.selectedMarker = nil
        }
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
        
        //set variables
        placeName = place.name
        chosenAddress = place.formattedAddress!
        
        //Set Address Label
        //locationAddress.text = (place.name)
        convertAddressToLatAndLong(eventAddress: chosenAddress)
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print ("Error auto complete \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Class to convert address from String to Coordinates
    func convertAddressToLatAndLong(eventAddress: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(eventAddress) {
            
            placemarks, error in
            let placemark = placemarks?.first
            self.lat = (placemark?.location?.coordinate.latitude)!
            self.lon = (placemark?.location?.coordinate.longitude)!
            
        }
        
        notificationField.isEnabled = true
        notificationSlider.isEnabled = true
        setLocationButton.isEnabled = true
        
    }
    
    func textFieldDidEndEditing(_ textView: UITextField) {
        
        
        //Increments of 25 meters
        if notificationField.text!.isEmpty || Int(notificationField.text!)! < 250{
            notificationField.text = "250"
        }
        if Int(notificationField.text!)! > 10000 {
            notificationField.text = "10000"
        }
        let roundedValue = round(Float(notificationField.text!)! / notifIncrement) * notifIncrement
        notificationSlider.value = roundedValue
        self.radius = Double(roundedValue)
        notificationField.text = String(Int(roundedValue))
        
        googleMapsView.clear()
        
        //Create Marker & Circle
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        marker.map = googleMapsView
        
        let circleCenter = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        let circ = GMSCircle(position: circleCenter, radius: Double(roundedValue))
        circ.fillColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 0.4)
        circ.strokeColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 0.5)
        
        
        circ.map = googleMapsView
        
        
    }


    
    @IBAction func didPressAddressSearch(_ sender: Any) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.country = "US"
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        //Increments of 25 meters
        let roundedValue = round(sender.value / notifIncrement) * notifIncrement
        sender.value = roundedValue
        notificationField.text = String(Int(roundedValue))
        
        googleMapsView.clear()
        
        //Create Marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        marker.map = googleMapsView
        
        self.radius = Double(sender.value)
        var currentValue = Int(sender.value)
        //self.notifyLabel.text = "Notify Those Within " + String(currentValue) + " Meters"
        let circleCenter = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        let circ = GMSCircle(position: circleCenter, radius: Double(sender.value))
        circ.fillColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 0.4)
        circ.strokeColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 0.5)
        circ.map = googleMapsView
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressSetLocation(_ sender: Any) {
        
        //Send Data Back
        if let presenter = presentingViewController as? NewEventViewController{
            

            presenter.eventAddress = chosenAddress
            presenter.lat = lat
            presenter.lon = lon
            presenter.eventRadius = radius
            presenter.locationButton.setTitle(chosenAddress + " | " + String(Int(radius)) + " Meters", for: .normal)
            
            if radius < 10000 {
                presenter.eventPriceLabel.text = "Event Total: $34.99"
            }
            if radius < 8500 {
                presenter.eventPriceLabel.text = "Event Total: $29.99"
            }
            if radius < 6000 {
                presenter.eventPriceLabel.text = "Event Total: $26.99"
            }
            if radius < 3100 {
                presenter.eventPriceLabel.text = "Event Total: $24.99"
            }
            if radius < 2000 {
                presenter.eventPriceLabel.text = "Event Total: $19.99"
            }
            if radius < 1000 {
                presenter.eventPriceLabel.text = "Event Total: $14.99"
            }
            if radius < 600 {
                presenter.eventPriceLabel.text = "Event Total: $9.99"
            }
            if radius < 400 {
                presenter.eventPriceLabel.text = "Event Total: $4.99"
            }
            if radius < 275 {
                presenter.eventPriceLabel.text = "Event Total: $2.99"
            }
            
        }
        

        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    

}
