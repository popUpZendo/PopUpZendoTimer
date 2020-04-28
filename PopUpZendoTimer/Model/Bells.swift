//
//  Bells.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 3/28/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import Foundation

enum Bells {
    case smallBell, mediumKesu, /*mediumKesuLong,*/ largeKesu, han
    
    var sound: String {
        switch self {
        case .smallBell: return "small-bell"
        case .mediumKesu: return "medium-kesu"
        //case .mediumKesuLong: return "medium-kesu-long"
        case .largeKesu: return "large-kesu"
        case .han: return "han"
        }
    }
    
    var ext: String {
        switch self {
        case .smallBell: return "aiff"
        case .mediumKesu: return "aiff"
        //case .mediumKesuLong: return "aiff"
        case .largeKesu: return "aiff"
        case .han: return "aiff"
        }
    }
    
    var image: String {
        switch self {
        case .smallBell: return "small-bell"
        case .mediumKesu: return "medium-kesu"
        //case .mediumKesuLong: return "medium-kesu-long"
        case .largeKesu: return "large-kesu"
        case .han: return "han"
        }
    }
}

let defaults = UserDefaults.standard

//var countdownNumber = defaults.countdownNumber
//var startNumber = defaults.startNumber
//var endNumber = defaults.
