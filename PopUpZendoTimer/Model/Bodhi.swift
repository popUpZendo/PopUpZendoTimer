//
//  Bodhi.swift
//  bodhi
//
//  Created by Joseph Hall on 10/26/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import Foundation
import Firebase

class Bodhi: Codable, Equatable {
    public var id: String { return name }
    public var name: String
    public var email: String
    public var city: String
    public var pic: String
    public var groups: [String]
    public var playerId: String
    public var senderId: String
    public var doan: Bool
    //public private(set) var key: String
    
    
    public static func ==(lhs: Bodhi, rhs: Bodhi) -> Bool {
        lhs.id == rhs.id
    }
    
    func save() {
           guard let json = self.toJSON else { return }
           Firestore.firestore().collection("bodhi").document(self.id).updateData(json)
       }
    
    
    
    
    init(name: String, email: String, city: String, pic: String, groups: [String], playerId: String, senderId: String, doan: Bool = false/*, key: String)*/) {
        self.name = name
        self.email = email
        self.city = city
        self.groups = groups
        self.pic = pic
        self.playerId = senderId
        self.senderId = playerId
        self.doan = doan
        //self.key = key
    }
    
   func toggleReadFlag() -> Bool {
       self.doan = !self.doan
       //normally make some call to toggle and return success/fail
       return true
   }
    
}
