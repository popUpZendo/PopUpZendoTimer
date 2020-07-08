//
//  OneSignalServices.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 7/3/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import Foundation
import OneSignal
import Firebase

class OneSignalService {
    
    static let instance = OneSignalService()
    
    var bodhi: Bodhi?
    var sangha: Group?
    var sanghaArray: [Group]?
    var doanryo = [""]
    var members: [Bodhi] = []
    var groupName = ""
    var players = [""]
    
    
    
    func uploadPlayerId(withPlayerId playerId: String, forUserId id: String, forUID uid: String, withKey Key: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if Key != nil {
            bodhi?.save()
            //sendComplete(true)
        } else {
            db.collection("bodhi").document(uid).updateData([
                "playerId": playerId,
                "senderId": uid
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("group successfully added!")
                }
            }
        }
    }
    var playerIdList = [""]
    
    func prepareToBroadcast(selectedGroup: String, completion: @escaping ([String]) -> Void) /*-> [String] */ {
        //        Access the data
        FirebaseInterface.instance.fetchGroups { sanghaArray in
            guard let sangha = sanghaArray.first(where: { $0.groupName.contains(selectedGroup) }) else { return }
            //Get an array of members
            FirebaseInterface.instance.fetchBodhiByID(ids: sangha.members.filter { $0 != uid}) { bodhi in
                // create an array of member ids from Group
                //self.members = bodhi
                //self.doanryo = sangha.members
                // Use those IDs to get playerIds from Bodhi list
                
                let playerIDs = bodhi.map { $0.playerId }
               
                // Remove user and empty strings from notification list
                //self.playerIdList = players.filter { $0 != member.senderId}
                // get playerIds for members
                //self.playerIdList = self.members.playerIds
                print("Prepare to Broadcast function called for \(sangha.groupName)")
                print("doanryo: \(self.doanryo)")
                print("PlayerIds: \(playerIDs)")
                
                completion(playerIDs)
            }
        }
        //return playerIdList for messaging
    }
    
    func broadcastBell(Group: String, audience: [String], Bell bell: String) {
        // See the Create notification REST API POST call for a list of all possible options: https://documentation.onesignal.com/reference#create-notification
        // NOTE: You can only use include_player_ids as a targeting parameter from your app. Other target options such as tags and included_segments require your OneSignal App REST API key which can only be used from your server.
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let pushToken = status.subscriptionStatus.pushToken
        let userId = status.subscriptionStatus.userId
        
        if pushToken != nil {
            let message = "Tap here to mute further bells"
            let notificationContent = [
                "include_player_ids": audience,
                "contents": ["en": message], // Required unless "content_available": true or "template_id" is set
                "headings": ["en": Group],
                "subtitle": ["en": "The Doan has rung a bell"],
                // If want to open a url with in-app browser
                //"url": "https://google.com",
                // If you want to deep link and pass a URL to your webview, use "data" parameter and use the key in the AppDelegate's notificationOpenedBlock
                "data": ["OpenURL": "https://imgur.com"],
                //                       "ios_attachments": ["id" : "https://cdn.pixabay.com/photo/2017/01/16/15/17/hot-air-balloons-1984308_1280.jpg"],
                "ios_sound": bell
                ] as [String : Any]
            
            OneSignal.postNotification(notificationContent)
        }
    }
    
}

