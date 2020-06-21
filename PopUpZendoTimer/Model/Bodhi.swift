//
//  Bodhi.swift
//  bodhi
//
//  Created by Joseph Hall on 10/26/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import Foundation

class Bodhi: Codable, Equatable {
    public var id: String { return name }
    public private(set) var name: String
    public private(set) var email: String
    public private(set) var city: String
    public private(set) var pic: String
    public private(set) var groups: [String]
    public private(set) var senderId: String
    public var doan: Bool
    //public private(set) var key: String
    
    
    public static func ==(lhs: Bodhi, rhs: Bodhi) -> Bool {
        lhs.id == rhs.id
    }
    
    
    
    
    init(name: String, email: String, city: String, pic: String, groups: [String], senderId: String, doan: Bool = false/*, key: String)*/) {
        self.name = name
        self.email = email
        self.city = city
        self.groups = groups
        self.pic = pic
        self.senderId = senderId
        self.doan = doan
        //self.key = key
    }
    
   func toggleReadFlag() -> Bool {
       self.doan = !self.doan
       //normally make some call to toggle and return success/fail
       return true
   }
    
}
