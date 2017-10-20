//
//  LocationNotification.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 10/15/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import UserNotifications


class LocationNotification: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    func updateLocation(sender: AnyObject){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        print("Location Tracking Started!")
    }
    
    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> CLLocationCoordinate2D  {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        return locValue
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            triggerTaskAssociatedWithRegionIdentifier(regionID: identifier)
        }
    }
    
    func triggerTaskAssociatedWithRegionIdentifier(regionID: String){
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default()
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if error != nil {
                // Handle any errors
            }
        }
        
    }
}
