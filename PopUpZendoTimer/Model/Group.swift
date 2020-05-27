//
//  Sangha.swift
//  PopUpZendo
//
//  Created by Joseph Hall on 9/23/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import Foundation

class Group {
    private var _groupName: String
    private var _weekday: String
    private var _time: Date
    private var _format: String
    private var _city: String
    private var _details: String
    private var _ino: String
    private var _roshi: String
    private var _website: String
    private var _zoom: String
    private var _temple: String
    private var _pic: String
    private var _logo: String
    private var _senderId: String
    private var _members: [String]
    //private var _key: String

    
    
    var groupName: String {
        return _groupName
    }
    
    var weekday: String {
        return _weekday
    }
    
    var time: Date {
        return _time
    }
    
    var format: String {
        return _format
    }
    
    var city: String {
        return _city
    }
    
    var details: String {
        return _details
    }
    
    var ino: String {
        return _ino
    }
    
    var roshi: String{
        return _roshi
    }
    
    var website: String{
        return _website
    }
    
    var zoom: String{
        return _zoom
    }
    
    var temple: String{
        return _temple
    }
    
    var pic: String{
        return _pic
    }
    
    var logo: String{
        return _logo
    }
    
    var senderId: String{
        return _senderId
    }
    
    var members: [String] {
        return _members
    }
   
//    var key: String {
//        return _key
//    }
    

    
    init(groupName: String, weekday: String, time: Date, format: String, city: String, details: String, ino: String, roshi: String, website: String, zoom: String, temple: String, pic: String, logo: String, senderId: String, members: [String] /*, key: String*/) {
        self._groupName = groupName
        self._weekday = weekday
        self._time = time
        self._format = format
        self._city = city
        self._details = details
        self._ino = ino
        self._roshi = roshi
        self._website = website
        self._zoom = zoom
        self._temple = temple
        self._pic = pic
        self._logo = logo
        self._senderId = senderId
        self._members = members
        //self._key = key
    }
}
