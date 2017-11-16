//
//  EventOverlay.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 11/7/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit
import MapKit

class EventOverlay: MKCircle {
    
    var eventIdentifier: String?
    var lat: Double?
    var lon: Double?
    var eventRadius: Double?
    
    convenience init(eventIdentifier: String, lat: Double, lon: Double, eventRadius: Double) {
        
        let eventCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.init(center: eventCoordinates, radius: eventRadius)
        self.eventIdentifier = eventIdentifier
        self.lat = lat
        self.lon = lon
        self.eventRadius = eventRadius
        return

    }
}
