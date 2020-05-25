//
//  Bodhi.swift
//  bodhi
//
//  Created by Joseph Hall on 10/26/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import Foundation

class Bodhi {
    private var _name: String
    private var _email: String
    private var _city: String
    private var _pic: String
    private var _groups: [String]
    private var _senderID: String
    private var _key: String
    
    
    var name: String {
        return _name
    }
    
    var email: String {
        return _email
    }
    
    var city: String {
        return _city
    }
    
    var pic: String {
        return _pic
    }
    
    var groups: [String] {
        return _groups
    }
    
    var senderID: String {
        return _senderID
    }
    
    
    
    
    
    init(name: String, email: String, city: String, pic: String, groups: [String], senderId: String, key: String) {
        self._name = name
        self._email = email
        self._city = city
        self._groups = groups
        self._pic = pic
        self._senderID = senderId
        self._key = key
    }
    
}
