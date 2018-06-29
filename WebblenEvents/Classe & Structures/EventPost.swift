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
    var title:String
    var shortDescription:String
    var longDescription:String
    var pathToImage:String
    var address:String
    var lat:Double
    var lon:Double
    var radius:Int
    var distanceFromUser:Int
    var tags:[String]
    var startDate:Date
    var endDate:Date
    var startTime:Date
    var endTime:Date
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
    
    var dictionary:[String:Any]{
        return [
            "title":title,
            "shortDescription":shortDescription,
            "longDescription":longDescription,
            "pathToImage":pathToImage,
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
            "reservePrice":reservePrice
        ]
    }
}

extension EventPost : DocumentSerializable {
    init?(dictionary: [String:Any]) {
        guard let title = dictionary["title"] as? String,
            let shortDescription = dictionary["shortDescription"] as? String,
            let longDescription = dictionary["longDescription"] as? String,
            let pathToImage = dictionary["pathToImage"] as? String,
            let address = dictionary["address"] as? String,
            let lat = dictionary["lat"] as? Double,
            let lon = dictionary["lon"] as? Double,
            let radius = dictionary["radius"] as? Int,
            let distanceFromUser = dictionary["distanceFromUser"] as? Int,
            let tags = dictionary["tags"] as? [String],
            let startDate = dictionary["startDate"] as? Date,
            let endDate = dictionary["endDate"] as? Date,
            let startTime = dictionary["startTime"] as? Date,
            let endTime = dictionary["endTime"] as? Date,
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
            let reservePrice = dictionary["reservePrice"] as? Double
        
            
            else {return nil}
        
        self.init(title: title, shortDescription: shortDescription, longDescription: longDescription, pathToImage: pathToImage, address: address, lat: lat, lon: lon, radius: radius, distanceFromUser: distanceFromUser, tags: tags, startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, published: published, hasMessageBoard: hasMessageBoard, messageBoardPassword: messageBoardPassword, author: author, authorImagePath: authorImagePath, verified: verified, promoted: promoted, views: views, event18: event18, event21: event21, explicit: explicit, attendanceRecordID: attendanceRecordID, spotsAvailable: spotsAvailable, reservePrice: reservePrice)
    }
}


//Event Coordinates v3
struct EventGeo {
    var title:String
    var shortDescription:String
    var pathToImage:String
    var address:String
    var lat:Double
    var lon:Double
    var radius:Int
    var distanceFromUser:Int
    
    var dictionary:[String:Any]{
        return [
            "title":title,
            "shortDescription":shortDescription,
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
            let shortDescription = dictionary["shortDescription"] as? String,
            let pathToImage = dictionary["pathToImage"] as? String,
            let address = dictionary["address"] as? String,
            let lat = dictionary["lat"] as? Double,
            let lon = dictionary["lon"] as? Double,
            let radius = dictionary["radius"] as? Int,
            let distanceFromUser = dictionary["distanceFromUser"] as? Int
            
            else {return nil}
        self.init(title: title, shortDescription: shortDescription, pathToImage: pathToImage, address: address, lat: lat, lon: lon, radius: radius, distanceFromUser: distanceFromUser)
    }
}
