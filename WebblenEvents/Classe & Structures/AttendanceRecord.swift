//
//  AttendanceRecord.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/28/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import Foundation

//Attendance Record v3
struct AttendanceRecord {
    var hosts:[String]
    var eventType:String
    var guestList:[String]
    var attendees:[String]
    var turnout:Double
    var lat:Double
    var lon:Double
    var payout:Double
    
    var dictionary:[String:Any]{
        return [
            "hosts":hosts,
            "eventType":eventType,
            "guestList":guestList,
            "attendees":attendees,
            "turnout":turnout,
            "lat":lat,
            "lon":lon,
            "payout":payout
        ]
    }
}

extension AttendanceRecord : DocumentSerializable {
    init?(dictionary: [String:Any]) {
        guard let hosts = dictionary["hosts"] as? [String],
            let eventType = dictionary["eventType"] as? String,
            let guestList = dictionary["guestList"] as? [String],
            let attendees = dictionary["attendees"] as? [String],
            let turnout = dictionary["turnout"] as? Double,
            let lat = dictionary["lat"] as? Double,
            let lon = dictionary["lon"] as? Double,
            let payout = dictionary["payout"] as? Double
            
            else {return nil}
        
        self.init(hosts: hosts, eventType: eventType, guestList: guestList, attendees: attendees, turnout: turnout, lat: lat, lon: lon, payout: payout)
    }
}
