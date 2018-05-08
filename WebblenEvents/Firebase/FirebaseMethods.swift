//
//  FirebaseMethods.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 4/9/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import Firebase
class FirebaseMethods {
    
    //Get Profile Pic From UID
    public static func loadProfilePic(from uid: String) -> NSURL{
        var pathToPic:String?
        var imgURL:NSURL?
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(uid).getDocument(completion: {(snapshot, error) in
            if !(snapshot?.exists)! {
                return
            } else if error != nil{
                print(error)
            } else {
                pathToPic = snapshot?.data()!["profile_pic"] as? String
                if pathToPic != nil {
                    imgURL = NSURL(string: pathToPic!)
                }
            }
        })
        return imgURL!
    }
}