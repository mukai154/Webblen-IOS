//
//  StringMethods.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 5/24/18.
//  Copyright © 2018 Mukai Selekwa. All rights reserved.
//

import Foundation

class StringMethods {
    
    //RANDOM STRING
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
