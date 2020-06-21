//
//  Sangha.swift
//  PopUpZendo
//
//  Created by Joseph Hall on 9/23/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import Foundation

class Group: Codable, Equatable {
    public var id: String { return groupName }
    public private(set) var groupName: String
    public private(set) var weekday: String
    public private(set) var time: String
    public private(set) var format: String
    public private(set) var city: String
    public private(set) var details: String
    public private(set) var ino: String
    public private(set) var roshi: String
    public private(set) var website: String
    public private(set) var zoom: String
    public private(set) var temple: String
    public private(set) var pic: String
    public private(set) var logo: String
    public private(set) var senderId: String
    public private(set) var members: [String]
    
    
    public static func ==(lhs: Group, rhs: Group) -> Bool {
        lhs.id == rhs.id
    }
    //private var _key: String

//    var key: String {
//        return _key
//    }
    

    
    init(groupName: String, weekday: String, time: String, format: String, city: String, details: String, ino: String, roshi: String, website: String, zoom: String, temple: String, pic: String, logo: String, senderId: String, members: [String] /*, key: String*/) {
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
        //self._key = key
    }
}
