//
//  documentStructures.swift
//  Webblen
//
//  Created by Mukai Selekwa on 11/12/17.
//  Copyright © 2018 Webblen. All rights reserved.
//

import Foundation
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
    var author_pic:String
    
    
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
            "views":views,
            "author_pic": author_pic
        ]
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

//Mini User Data Structure
struct webblenUserBasicData {
    var username:String
    var profile_pic:String
    var uid:String
    
    var dictionary:[String:Any]{
        return[
            "username":username,
            "profile_pic":profile_pic,
            "uid":uid
        ]
    }
}

extension webblenUserBasicData : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let username = dictionary["username"] as? String,
            let profile_pic = dictionary["profile_pic"] as? String,
            let uid = dictionary["uid"] as? String
            else {return nil}
        self.init(username: username, profile_pic: profile_pic, uid: uid)
    }
}

//Group Structure
struct webblenGroup {
    var groupName:String
    var members:[String]
    var invited:[String]
    var suggestedEvents:[String]
    var totalWebPower:Double
    var chatID:String

    
    var dictionary:[String:Any]{
        return[
            "groupName":groupName,
            "members":members,
            "invited":invited,
            "suggestedEvents":suggestedEvents,
            "totalWebPower":totalWebPower,
            "chatID":chatID
        ]
    }
}

extension webblenGroup : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let groupName = dictionary["groupName"] as? String,
            let members = dictionary["members"] as? [String],
            let invited = dictionary["invited"] as? [String],
            let suggestedEvents = dictionary["suggestedEvents"] as? [String],
            let totalWebPower = dictionary["totalWebPower"] as? Double,
            let chatID = dictionary["chatID"] as? String
            else {return nil}
        self.init(groupName: groupName, members: members, invited: invited, suggestedEvents: suggestedEvents, totalWebPower: totalWebPower, chatID: chatID)
    }
}

//Message Structure
struct chatMessage {
    var messageText:String
    var messagePicUrl:String
    var senderUID:String
    var senderPicUrl:String
    var messageKey:String
    var messageChatID:String
    var timeSent:String
    
    var dictionary:[String:Any]{
        return[
            "messageText":messageText,
            "messagePicUrl":messagePicUrl,
            "senderUID":senderUID,
            "senderPicUrl":senderPicUrl,
            "messageKey":messageKey,
            "messageChatID":messageChatID,
            "timeSent":timeSent
        ]
    }
}

extension chatMessage : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let messageText = dictionary["messageText"] as? String,
            let messagePicUrl = dictionary["messagePicUrl"] as? String,
            let senderUID = dictionary["senderUID"] as? String,
            let senderPicUrl = dictionary["senderPicUrl"] as? String,
            let messageKey = dictionary["messageKey"] as? String,
            let messageChatID = dictionary["messageChatID"] as? String,
            let timeSent = dictionary["timeSent"] as? String
            else {return nil}
        self.init(messageText: messageText, messagePicUrl: messagePicUrl, senderUID: senderUID, senderPicUrl: senderPicUrl, messageKey: messageKey, messageChatID: messageChatID, timeSent: timeSent)
    }
}


