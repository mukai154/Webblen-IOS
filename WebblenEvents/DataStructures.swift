//
//  documentStructures.swift
//  Webblen
//
//  Created by Mukai Selekwa on 11/12/17.
//  Copyright © 2018 Webblen. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct SortableRegion {
    var distance: Double
    var region: CLCircularRegion
}

//Event Structure
struct webblenEvent {
    var title:String
    var address:String
    var categories:[String]
    var date:String
    var description:String
    var eventKey:String
    var lat:Double
    var lon:Double
    var paid:Bool
    var pathToImage:String
    var radius:Double
    var time:String
    var author:String
    var verified:Bool
    var views:Int
    var event18:Bool
    var event21:Bool
    var notificationOnly:Bool
    var distanceFromUser:Double
    
    var dictionary:[String:Any]{
        return [
            "address":address,
            "author":author,
            "categories":categories,
            "date":date,
            "descrption":description,
            "distanceFromUser": distanceFromUser,
            "eventKey":eventKey,
            "event18":event18,
            "event21":event21,
            "lat":lat,
            "lon":lon,
            "notificationOnly":notificationOnly,
            "paid":paid,
            "pathToImage":pathToImage,
            "radius":radius,
            "time":time,
            "title":title,
            "verified":verified,
            "views":views
        ]
    }
}

extension webblenEvent : DocumentSerializable {
    init?(dictionary: [String:Any]) {
        guard let address = dictionary["address"] as? String,
        let author = dictionary["author"] as? String,
        let categories = dictionary["author"] as? [String],
        let date = dictionary["author"] as? String,
        let description = dictionary["description"] as? String,
        let distanceFromUser = dictionary["distanceFromUser"] as? Double,
        let eventKey = dictionary["author"] as? String,
        let event18 = dictionary["event18"] as? Bool,
        let event21 = dictionary["event21"] as? Bool,
        let lat = dictionary["lat"] as? Double,
        let lon = dictionary["lon"] as? Double,
        let notificationOnly = dictionary["notificationOnly"] as? Bool,
        let paid = dictionary["author"] as? Bool,
        let pathToImage = dictionary["author"] as? String,
        let radius = dictionary["author"] as? Double,
        let time = dictionary["author"] as? String,
        let title = dictionary["author"] as? String,
        let verified = dictionary["author"] as? Bool,
        let views = dictionary["author"] as? Int
            else {return nil}
        self.init(title: title, address: address, categories: categories, date: date, description: description, eventKey: eventKey, lat: lat, lon: lon, paid: paid, pathToImage: pathToImage, radius: radius, time: time, author: author, verified: verified, views: views, event18: event18, event21: event21, notificationOnly: notificationOnly, distanceFromUser: distanceFromUser)
    }
}

//User Structure
struct webblenUser {
    var eventPoints:Int
    var interests:[String]
    var isOver18:Bool
    var isOver21:Bool
    var isVerified:Bool
    var username:String
    var uid:String
    
    var dictionary:[String:Any]{
        return[
            "eventPoints":eventPoints,
            "interests":interests,
            "isOver18":isOver18,
            "isOver21":isOver21,
            "isVerified":isVerified,
            "username":username,
            "uid":uid
        ]
    }
}

extension webblenUser : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let eventPoints = dictionary["eventPoints"] as? Int,
        let interests = dictionary["interests"] as? [String],
        let isOver18 = dictionary["isOver18"] as? Bool,
        let isOver21 = dictionary["isOver21"] as? Bool,
        let isVerified = dictionary["isVerified"] as? Bool,
        let username = dictionary["username"] as? String,
        let uid = dictionary["uid"] as? String
            else {return nil}
        self.init(eventPoints: eventPoints, interests: interests, isOver18: isOver18, isOver21: isOver21, isVerified: isVerified, username: username, uid: uid)
    }
}


