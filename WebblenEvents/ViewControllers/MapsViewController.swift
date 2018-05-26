//
//  MapsViewController.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 8/4/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GoogleMaps

class MapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {

    //Outlets
    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var setAddressButton: UIButton!


    
    //Variables
    var locationManager = CLLocationManager()
    var chosenAddress = "address"
    var placeName = "place"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddressButton.isEnabled = false
        setAddressButton.isHidden = true
        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        
        //Create Marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.name
        marker.map = googleMapsView
        
        self.googleMapsView.camera = camera
        
        //set variables
        placeName = place.name
        chosenAddress = place.formattedAddress!
        
        //Set Address Label
        locationAddress.text = (place.name)
        
        setAddressButton.isEnabled = true
        setAddressButton.isHidden = false
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print ("Error auto complete \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Autocomplete search address
    @IBAction func openSearchAddress(_ sender: UIBarButtonItem) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.country = "US"
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func didPressSetLocation(_ sender: Any) {
        
        if (chosenAddress.contains(", USA")){
            let endIndex = chosenAddress.index(chosenAddress.endIndex, offsetBy: -5)
            let modifiedAddress = chosenAddress.substring(to: endIndex)
            if let presenter = presentingViewController as? NewEventViewController{
                presenter.locationButton.setTitle(modifiedAddress, for: .normal)
            }
            dismiss(animated: true, completion: nil)
            
        }
        
        else {
            let alert = UIAlertController(title: "Event Address Error", message: "Please select a location in Fargo, ND", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    


    
    @IBAction func didPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
