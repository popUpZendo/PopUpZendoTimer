//
//  Sangha.swift
//  PopUpZendo
//
//  Created by Joseph Hall on 9/23/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import Foundation
import Firebase

class Group: Codable, Equatable {
    public var id: String { return groupName }
    public var groupName: String
    public var weekday: String
    public var time: String
    public var format: String
    public var city: String
    public var details: String
    public var ino: String
    public var roshi: String
    public var website: String
    public var zoom: String
    public var temple: String
    public var pic: String
    public var logo: String
    public var senderId: String
    public var members: [String]
    public var doans: [String]
    
    
    public static func ==(lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
    //private var _key: String

//    var key: String {
//        return _key
//    }
    
    func save() {
        guard let json = self.toJSON else { return }
        Firestore.firestore().collection("groups").document(self.id).updateData(json)
    }

    
    init(groupName: String, weekday: String, time: String, format: String, city: String, details: String, ino: String, roshi: String, website: String, zoom: String, temple: String, pic: String, logo: String, senderId: String, members: [String], doans: [String] /*, key: String*/) {
        self.groupName = groupName
        self.weekday = weekday
        self.time = time
        self.format = format
        self.city = city
        self.details = details
        self.ino = ino
        self.roshi = roshi
        self.website = website
        self.zoom = zoom
        self.temple = temple
        self.pic = pic
        self.logo = logo
        self.senderId = senderId
        self.members = members
        self.doans = doans
        //self._key = key
    }
}
