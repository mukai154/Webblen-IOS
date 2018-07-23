//
//  EventPost.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 6/28/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import Foundation

//Event Structure v3
struct EventPost {
    var eventKey:String
    var title:String
    var caption:String
    var description:String
    var pathToImage:String
    var uploadedImage:Any
    var address:String
    var lat:Double
    var lon:Double
    var radius:Double
    var distanceFromUser:Double
    var tags:[String]
    var startDate:String
    var endDate:String
    var startTime:String
    var endTime:String
    var published:Bool
    var hasMessageBoard:Bool
    var messageBoardPassword:String
    var author:String
    var authorImagePath:String
    var verified:Bool
    var promoted:Bool
    var views:Int
    var event18:Bool
    var event21:Bool
    var explicit:Bool
    var attendanceRecordID:String
    var spotsAvailable:Int
    var reservePrice:Double
    var website:String
    var fbSite:String
    var twitterSite:String
    
    var dictionary:[String:Any]{
        return [
            "eventKey":eventKey,
            "title":title,
            "caption":caption,
            "description":description,
            "pathToImage":pathToImage,
            "uploadedImage":uploadedImage,
            "address":address,
            "lat":lat,
            "lon":lon,
            "radius":radius,
            "distanceFromUser":distanceFromUser,
            "tags":tags,
            "startDate":startDate,
            "endDate":endDate,
            "startTime":startTime,
            "endTime":endTime,
            "published":published,
            "hasMessageBoard":hasMessageBoard,
            "messageBoardPassword":messageBoardPassword,
            "author":author,
            "authorImagePath":authorImagePath,
            "verified":verified,
            "promoted":promoted,
            "views":views,
            "event18":event18,
            "event21":event21,
            "explicit":explicit,
            "attendanceRecordID":attendanceRecordID,
            "spotsAvailable":spotsAvailable,
            "reservePrice":reservePrice,
            "website":website,
            "fbSite":fbSite,
            "twitterSite":twitterSite
        ]
    }
}

extension EventPost : DocumentSerializable {
    init?(dictionary: [String:Any]) {
        guard let eventKey = dictionary["eventKey"] as? String,
            let title = dictionary["title"] as? String,
            let caption = dictionary["shortDescription"] as? String,
            let description = dictionary["description"] as? String,
            let pathToImage = dictionary["pathToImage"] as? String,
            let uploadedImage = dictionary["uploadedImage"] as? Any,
            let address = dictionary["address"] as? String,
            let lat = dictionary["lat"] as? Double,
            let lon = dictionary["lon"] as? Double,
            let radius = dictionary["radius"] as? Double,
            let distanceFromUser = dictionary["distanceFromUser"] as? Double,
            let tags = dictionary["tags"] as? [String],
            let startDate = dictionary["startDate"] as? String,
            let endDate = dictionary["endDate"] as? String,
            let startTime = dictionary["startTime"] as? String,
            let endTime = dictionary["endTime"] as? String,
            let published = dictionary["published"] as? Bool,
            let hasMessageBoard = dictionary["hasMessageBoard"] as? Bool,
            let messageBoardPassword = dictionary["messageBoardPassword"] as? String,
            let author = dictionary["author"] as? String,
            let authorImagePath = dictionary["authorImagePath"] as? String,
            let verified = dictionary["verified"] as? Bool,
            let promoted = dictionary["promoted"] as? Bool,
            let views = dictionary["views"] as? Int,
            let event18 = dictionary["event18"] as? Bool,
            let event21 = dictionary["event21"] as? Bool,
            let explicit = dictionary["explicit"] as? Bool,
            let attendanceRecordID = dictionary["attendanceRecordID"] as? String,
            let spotsAvailable = dictionary["spotsAvailable"] as? Int,
            let reservePrice = dictionary["reservePrice"] as? Double,
            let website = dictionary["website"] as? String,
            let fbSite = dictionary["fbSite"] as? String,
            let twitterSite = dictionary["twitterSite"] as? String
            
            else {return nil}
        
        self.init(eventKey: eventKey, title: title, caption: caption, description: description, pathToImage: pathToImage, uploadedImage: uploadedImage, address: address, lat: lat, lon: lon, radius: radius, distanceFromUser: distanceFromUser, tags: tags, startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, published: published, hasMessageBoard: hasMessageBoard, messageBoardPassword: messageBoardPassword, author: author, authorImagePath: authorImagePath, verified: verified, promoted: promoted, views: views, event18: event18, event21: event21, explicit: explicit, attendanceRecordID: attendanceRecordID, spotsAvailable: spotsAvailable, reservePrice: reservePrice, website: website, fbSite: fbSite, twitterSite: twitterSite)
    }
}


//Event Coordinates v3
struct EventGeo {
    var title:String
    var caption:String
    var pathToImage:String
    var address:String
    var lat:Double
    var lon:Double
    var radius:Int
    var distanceFromUser:Int
    
    var dictionary:[String:Any]{
        return [
            "title":title,
            "caption":caption,
            "pathToImage":pathToImage,
            "address":address,
            "lat":lat,
            "lon":lon,
            "radius":radius,
            "distanceFromUser":distanceFromUser
        ]
    }
}

extension EventGeo : DocumentSerializable {
    init?(dictionary: [String:Any]) {
        guard let title = dictionary["title"] as? String,
            let caption = dictionary["caption"] as? String,
            let pathToImage = dictionary["pathToImage"] as? String,
            let address = dictionary["address"] as? String,
            let lat = dictionary["lat"] as? Double,
            let lon = dictionary["lon"] as? Double,
            let radius = dictionary["radius"] as? Int,
            let distanceFromUser = dictionary["distanceFromUser"] as? Int
            
            else {return nil}
        self.init(title: title, caption: caption, pathToImage: pathToImage, address: address, lat: lat, lon: lon, radius: radius, distanceFromUser: distanceFromUser)
    }
}
