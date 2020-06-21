//
//  DataServices.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/1/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


let db = Firestore.firestore()
// uid can be nil if user haven't log in yet, force unwrapping it here will cause crash
// use String! to store possible nil value, the "!" means it will auto unwrap optional when you use it
var uid : String! = Auth.auth().currentUser?.uid
let storage = Storage.storage()


class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = db
    private var _REF_USERS = db.collection("users")
    private var _REF_GROUPS = db.collection("groups")
    private var _REF_BODHI = db.collection("bodhi")
    
    
    var REF_BASE: Firestore {
        return _REF_BASE
    }
    
    var REF_USERS: CollectionReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: CollectionReference {
        return _REF_GROUPS
    }
    
    var REF_BODHI: CollectionReference {
        return _REF_BODHI
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.addDocument(data: userData)
    }
    
    func createProfile(uid: String, userData: Dictionary<String, Any>) {
        REF_BODHI.addDocument(data: userData)
    }
    
    
//    func getUsername(forUID uid: String, handler: @escaping (_ username: String?) -> ()) {
//        REF_USERS.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//        }
    

    
            func createBodhi(withName name: String, withEmail email: String, withCity city: String, withSenderID senderID: String, forUID uid: String, withBodhiKey bodhiKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
                db.collection("bodhi").document(uid).setData([
                     "Name": name,
                     "Email": email,
                     "City": city,
                     "Groups": [""],
                     "senderId": uid
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                }
    
 
    
    func selectGroup(withName name: String, withSenderID senderID: String, forUID uid: String, withBodhiKey bodhiKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        db.collection("groups").document(name).updateData([
                   "members": FieldValue.arrayUnion([uid])
               ]) { err in
                   if let err = err {
                       print("Error writing document: \(err)")
                   } else {
                       print("group successfully added!")
                   }
               }
        
        db.collection("bodhi").document(uid).updateData([
            "groups": FieldValue.arrayUnion([name]),
            "senderId": uid
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("group successfully added!")
            }
        }
        
        
    }
    
    
    func leaveGroup(withName name: String, withSenderID senderID: String, forUID uid: String, withBodhiKey bodhiKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
           
           db.collection("groups").document(name).updateData([
                      "members": FieldValue.arrayRemove([uid])
                  ]) { err in
                      if let err = err {
                          print("Error writing document: \(err)")
                      } else {
                          print("group successfully added!")
                      }
                  }
           
           db.collection("bodhi").document(uid).updateData([
               "groups": FieldValue.arrayRemove([name]),
               "senderId": uid
           ]) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("group successfully added!")
               }
           }
           
           
       }
    
             
    func createGroup(withGroupName groupName: String, withWeekday weekday: String, withTime time: String, withFormat format: String, withDetails details: String, withCity city: String, withIno ino: String, withRoshi roshi: String, withWebsite website: String, withZoom zoom: String, withTemple temple: String, withPic pic: String, withLogo logo: String, withMembers members: [String], withSenderID senderID: String, forUID uid: String, withBodhiKey bodhiKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
            db.collection("groups").document(groupName).setData([
                 "groupName": groupName,
                 "weekday": weekday,
                 "time": time,
                 "format": format,
                 "details": details,
                 "city": city,
                 "ino": ino,
                 "roshi": roshi,
                 "website": website,
                 "zoom": zoom,
                 "temple": temple,
                 "pic": pic,
                 "logo": logo,
                 "members": members,
                 "senderId": uid
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
    }
      
    func getProfileInfo(forUID uid: String) {
                let docRef = db.collection("bodhi").document(uid)

                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                    } else {
                        print("Document does not exist")
                    }
                }
    }

            
    func updateBodhi(withName name: String, withEmail email: String, withCity city: String, withPic pic: String, withSenderID senderID: String, forUID uid: String, withBodhiKey bodhiKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
            db.collection("bodhi").document(uid).updateData([
                 "Name": name,
                 "Email": email,
                 "City": city,
                 "Pic": pic,
                 //"Groups": groups,
                 "senderId": uid
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            }
    
    func getAllGroups(handler: @escaping (_ sanghaArray: [Group]) -> ()) {
        var sanghaArray = [Group]()
        db.collection("groups")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                    
                }
                for document in documents {
                let groupName = document.get("groupName") as! String
                let weekday = document.get("weekday") as! String
                //let timeStamp = document.get("time") as! String
                let time = document.get("time") as! String
                let format = document.get("format") as! String
                let city = document.get("city") as! String
                let details = document.get("details") as! String
                let ino = document.get("ino") as! String
                let roshi = document.get("roshi") as! String
                let website = document.get("website") as! String
                let zoom = document.get("zoom") as! String
                let temple = document.get("temple") as! String
                let pic = document.get("pic") as! String
                let logo = document.get("logo") as! String
                let memberArray = document.get("members") as! [String]
                //let members = documents.document.map { $0["Members"]! as? [String]}
                let senderId = document.get("senderId") as! String
                    let sangha = Group(groupName: groupName, weekday: weekday, time: time, format: format, city: city, details: details, ino: ino, roshi: roshi, website: website, zoom: zoom, temple: temple, pic: pic, logo: logo, senderId: senderId, members: memberArray)
                sanghaArray.append(sangha)
        
                }
        handler(sanghaArray)
        }
    }
    
//    func getAllGroups(handler: @escaping (_ sanghaArray: [Sangha]) -> ()) {
//        var sanghaArray = [Sangha]()
//        db.collection("groups")
//            .addSnapshotListener { querySnapshot, error in
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching documents: \(error!)")
//                    return}
//                for sangha in documents {
//                let groupName = documents.map { $0["Group Name"]! as! String }
//                let weekday = documents.map { $0["Weekday"]! as! String}
//                let time = documents.map { $0["Time"]! as! Date}
//                let details = documents.map { $0["Details"]! as! String}
//                let city = documents.map { $0["City"]! as! String}
//                let ino = documents.map { $0["ino"]! as! String}
//                //let memberArray = documents.document.map { $0["Members"]! as? [String]}
//                let senderId = documents.map { $0["SenderId"]! as! String}
//                let sangha = Sangha(groupName: groupName, weekday: weekday, time: time, city: city, details: details, ino: ino)
//                sanghaArray.append(sangha)
//
//                }
//        handler(sanghaArray)
//        }
//    }
                                     
                                 
                   
//
//        func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
//            var groupsArray = [Group]()
//            REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
//                guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return}
//
//                for group in groupSnapshot {
//                    let memberArray = group.childSnapshot(forPath: "members").value as! [String]
//                    if memberArray.contains((Auth.auth().currentUser?.uid)!) {
//                        let title = group.childSnapshot(forPath: "title").value as! String
//                        let description = group.childSnapshot(forPath: "description").value as! String
//                        let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
//                        groupsArray.append(group)
//                    }
//                }
//                handler(groupsArray)
//            }
//        }
        
//         db.collection("groups")
//                  .addSnapshotListener { querySnapshot, error in
//                      guard let documents = querySnapshot?.documents else {
//                          print("Error fetching documents: \(error!)")
//                          return
//                      }
//                    let groupName = documents.map { $0["Group Name"]! }
//                    let weekday = documents.map { $0["Weekday"]! }
//                    let time = documents.map { $0["Time"]! }
//                    let city = documents.map { $0["City"]! }
//                    let details = documents.map { $0["Details"]! }
//                    let ino = documents.map { $0["ino"]! }
//                    let members = documents.map { $0["Members"]! }
//                      print("Current data from Firestore: \(groupName)")
//                  }
      }
    

    
//            for sangha in sanghas {
//                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
//                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
//                    let title = group.childSnapshot(forPath: "title").value as! String
//                    let description = group.childSnapshot(forPath: "description").value as! String
//                    let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
//                    groupsArray.append(group)
//                }
//            }
//            handler(groupsArray)
 //       }
  //  }
    
    
            
    
    
            
//             func uploadBodhi(withName name: String, withPopUpGroup popUpGroup: String, withCity city: String, withState state: String, withTemple temple: String, withTeacher teacher: String, withPractice practice: String, forUID uid: String, withBodhiKey bodhiKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
//                    if bodhiKey != nil {
//                        REF_BODHI.document(bodhiKey!).document("profile").documentByAutoId().setValue(["Name": name, "PopUpGroup": popUpGroup, "City": city, "State": state, "Temple": temple, "Teacher": teacher, "Practice": practice, "senderId": uid])
//                        sendComplete(true)
//                    } else {
//                        REF_BODHI.document(uid).setValue(["Name": name, "PopUpGroup": popUpGroup, "City": city, "State": state, "Temple": temple, "Teacher": teacher, "Practice": practice,"senderId": uid])
//                        sendComplete(true)
//                    }
//                }
            
            
//            guard let userSnapshot = querySnapshot?.documents as? [DataSnapshot] else { return }
//            for user in userSnapshot {
//                if user.key == uid {
//                    handler(user.documentSnapshot(forPath: "pic").value as! String)
//        }
//    }
//
//
//        observeSingleEvent(of: .value) { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
//            for user in userSnapshot {
//                if user.key == uid {
//                    handler(user.documentSnapshot(forPath: "username").value as? String ?? "defaultValue")
//                }
//            }
//        }
//    }
//
//        db.collection("cities").whereField("capital", isEqualTo: true)
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                    }
//                }
//        }
//        ViewController.swift
//
//
//
//
//
//
//    func getPic(forUID uid: String, handler: @escaping (_ pic: String) -> ()) {
//        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
//            for user in userSnapshot {
//                if user.key == uid {
//                    handler(user.documentSnapshot(forPath: "pic").value as! String)
//                }
//            }
//        }
//    }
//
//    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, withConversationKey conversationKey: String?,sendComplete: @escaping (_ status: Bool) -> ()) {
//        if groupKey != nil {
//            REF_GROUPS.document(groupKey!).document("messages").documentByAutoId().updatedocumentValues(["content": message, "senderId": uid])
//            sendComplete(true)
//        } else {
//            REF_FEED.documentByAutoId().updatedocumentValues(["content": message, "senderId": uid])
//            sendComplete(true)
//        }
//        if conversationKey != nil {
//            REF_CONVERSATION.document(conversationKey!).document("messages").documentByAutoId().updatedocumentValues(["content": message, "senderId": uid])
//            sendComplete(true)
//        } else {
//            REF_FEED.documentByAutoId().updatedocumentValues(["content": message, "senderId": uid])
//            sendComplete(true)
//        }
//    }
//
//
//    func uploadBodhi(withName name: String, withPopUpGroup popUpGroup: String, withCity city: String, withState state: String, withTemple temple: String, withTeacher teacher: String, withPractice practice: String, forUID uid: String, withBodhiKey bodhiKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
//        if bodhiKey != nil {
//            REF_BODHI.document(bodhiKey!).document("profile").documentByAutoId().setValue(["Name": name, "PopUpGroup": popUpGroup, "City": city, "State": state, "Temple": temple, "Teacher": teacher, "Practice": practice, "senderId": uid])
//            sendComplete(true)
//        } else {
//            REF_BODHI.document(uid).setValue(["Name": name, "PopUpGroup": popUpGroup, "City": city, "State": state, "Temple": temple, "Teacher": teacher, "Practice": practice,"senderId": uid])
//            sendComplete(true)
//        }
//    }
//
//    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
//        var messageArray = [Message]()
//        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
//            guard let feedMessageSnapshot = feedMessageSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
//
//            for message in feedMessageSnapshot {
//                let content = message.documentSnapshot(forPath: "content").value as! String
//                let senderId = message.documentSnapshot(forPath: "senderId").value as! String
//                //let pic = message.documentSnapshot(forPath: "pic").value as! String
//                let message = Message(content: content, senderId: senderId)
//                messageArray.append(message)
//            }
//
//            handler(messageArray)
//        }
//    }
//
//
//
//    func getAllBodhi(handler: @escaping (_ bodhi: [Bodhi]) -> ()) {
//        var bodhiArray = [Bodhi]()
//        REF_BODHI.observeSingleEvent(of: .value) { (bodhiSnapshot) in
//            guard let bodhiSnapshot = bodhiSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
//
//            for bodhi in bodhiSnapshot {
//                let name = bodhi.documentSnapshot(forPath: "Name").value as! String
//                let popUpGroup = bodhi.documentSnapshot(forPath: "PopUpGroup").value as! String
//                let city = bodhi.documentSnapshot(forPath: "City").value as! String
//                let state = bodhi.documentSnapshot(forPath: "State").value as! String
//                let temple = bodhi.documentSnapshot(forPath: "Temple").value as! String
//                let teacher = bodhi.documentSnapshot(forPath: "Teacher").value as! String
//                let practice = bodhi.documentSnapshot(forPath: "Practice").value as! String
//                let senderId = bodhi.documentSnapshot(forPath: "senderId").value as! String
//                //let key = bodhi.documentSnapshot(forPath: "key").value as! String
//                let bodhi = Bodhi(name: name, popUpGroup: popUpGroup, city: city, state: state, temple: temple, teacher: teacher, practice: practice, senderId: senderId, key: bodhi.key)
//                bodhiArray.append(bodhi)
//                print(bodhiArray)
//            }
//
//            handler(bodhiArray)
//        }
//    }
//
//    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()) {
//        var groupMessageArray = [Message]()
//        REF_GROUPS.document(desiredGroup.key).document("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
//            guard let groupMessageSnapshot = groupMessageSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
//            for groupMessage in groupMessageSnapshot {
//                let content = groupMessage.documentSnapshot(forPath: "content").value as! String
//                let senderId = groupMessage.documentSnapshot(forPath: "senderId").value as! String
//                let groupMessage = Message(content: content, senderId: senderId)
//                groupMessageArray.append(groupMessage)
//            }
//            handler(groupMessageArray)
//        }
//    }
//
//    func getConversation(desiredConversation: Conversation, handler: @escaping (_ messagesArray: [Message]) -> ()) {
//        var conversationMessageArray = [Message]()
//        REF_CONVERSATION.document(desiredConversation.key).document("messages").observeSingleEvent(of: .value) { (conversationMessageSnapshot) in
//            guard let conversationMessageSnapshot = conversationMessageSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
//            for conversationMessage in conversationMessageSnapshot {
//                let content = conversationMessage.documentSnapshot(forPath: "content").value as! String
//                let senderId = conversationMessage.documentSnapshot(forPath: "senderId").value as! String
//                let conversationMessage = Message(content: content, senderId: senderId)
//                conversationMessageArray.append(conversationMessage)
//            }
//            handler(conversationMessageArray)
//        }
//    }
//
//
////    func getConversationMembers(desiredConversation: Conversation, handler: @escaping (_ conversationMembersArray: [Conversation]) -> ()) {
////        var conversationMessageArray = [Conversation]()
////
//////        self.ref?
//////            .document("data")
//////            .document("success")
//////            .document(userID!)
//////            .observeSingleEvent(of: .value, with: { (snapshot) in
//////                if let data = snapshot.value as? [String: Any] {
//////                    let keys = Array(data.keys)
//////                    let values = Array(data.values)
//////                    ... // Your code here
//////                }
//////            }
////
////
////        REF_CONVERSATION.document(desiredConversation.key).document("members").observeSingleEvent(of: .value) { (conversationMembersSnapshot) in
////
////            guard let conversationMembersSnapshot = conversationMembersSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
////            for conversationMembers in conversationMembersSnapshot {
////                 let members = conversationMembers.documentSnapshot(forPath: "members").value as! String
////                conversationMessageArray.append(conversationMembers)
////            }
////            handler(conversationMembersArray)
////        }
////    }
//
//    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
//        var emailArray = [String] ()
//        REF_USERS.observe(.value) { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.documentren.allObjects as? [DataSnapshot] else {return}
//            for user in userSnapshot {
//                let email = user.documentSnapshot(forPath: "email").value as! String
//
//                if email.contains(query) == true && email != Auth.auth().currentUser?.email{
//                    emailArray.append(email)
//                }
//            }
//            handler(emailArray)
//        }
//    }
//
//
//    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
//        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
//            var idArray = [String]()
//            guard let userSnapshot = userSnapshot.documentren.allObjects as? [DataSnapshot] else {return}
//            for user in userSnapshot {
//                let email = user.documentSnapshot(forPath: "email").value as! String
//                if usernames.contains(email) {
//                    idArray.append(user.key)
//                }
//            }
//            handler(idArray)
//        }
//    }
//
//
//
//    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
//        var emailArray = [String]()
//        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
//            for user in userSnapshot {
//                if group.members.contains(user.key) {
//                    let email = user.documentSnapshot(forPath: "email").value as! String
//                    emailArray.append(email)
//                }
//            }
//            handler(emailArray)
//        }
//    }
//
//    func getEmailsForConversation(conversation: Conversation, handler: @escaping (_ emailArray: [String]) -> ()) {
//        var emailArray = [String]()
//        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.documentren.allObjects as? [DataSnapshot] else { return }
//            for user in userSnapshot {
//                if conversation.conversationMembers.contains(user.key) {
//                    let email = user.documentSnapshot(forPath: "email").value as! String
//                    emailArray.append(email)
//                }
//            }
//            handler(emailArray)
//        }
//    }
//
//    func createConversation(withTitle title: String, forUserIds ids: [String], handler: @escaping (_ conversationCreated: Bool) -> ()) {
//        REF_CONVERSATION.documentByAutoId().updatedocumentValues(["title": title, "members": ids])
//        //    need to add code here for slow internet: if successful connection true else error
//        handler(true)
//    }
//
//    func getAllConversations(handler: @escaping (_ conversationsArray: [Conversation]) -> ()) {
//        var partner = [""]
//        var title: String = ""
//        var partnerName = ""
//
//        var conversationsArray = [Conversation]()
//        REF_CONVERSATION.observeSingleEvent(of: .value) { (conversationSnapshot) in
//            guard let conversationSnapshot = conversationSnapshot.documentren.allObjects as? [DataSnapshot] else { return}
//            for conversation in conversationSnapshot {
//                let memberArray = conversation.documentSnapshot(forPath: "members").value as! [String]
//                partner = memberArray.filter {$0 != (Auth.auth().currentUser?.uid)!}
//                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
//
//                    let newPartner = (String(describing: partner))
//                    title = newPartner.replacingOccurrences(of: "[\\[\\]\\^+<>\"]", with: "", options: .regularExpression, range: nil)
//
//                        databaseRef.document("bodhi").document(title).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                            if let bodhiDict = snapshot.value as? [String: AnyObject]
//                            {
//
//                                partnerName = (bodhiDict["Name"] as! String)
//                                    print ("partnerName returned from firebase: \(partnerName)")
//                                // Point A:This prints "Sandy"
//                            }
//                        })
//
//                    print ("partnerName: \(partnerName)")
//                    // This prints nothing but if I add partnerName = "Sandy", then the function complete
//                    title = partnerName
//                    print ("new title: \(title)")
//                    let conversation = Conversation(conversationTitle: title, key: conversation.key, conversationMembers: memberArray, conversationMemberCount: memberArray.count)
//                    conversationsArray.append(conversation)
//                }
//            }
//            handler(conversationsArray)
//        }
//    }
//
//    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
//        REF_GROUPS.documentByAutoId().updatedocumentValues(["title": title, "description": description, "members": ids])
//        //    need to add code here for slow internet: if successful connection true else error
//        handler(true)
//    }
//
//    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
//        var groupsArray = [Group]()
//        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
//            guard let groupSnapshot = groupSnapshot.documentren.allObjects as? [DataSnapshot] else { return}
//            for group in groupSnapshot {
//                let memberArray = group.documentSnapshot(forPath: "members").value as! [String]
//                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
//                    let title = group.documentSnapshot(forPath: "title").value as! String
//                    let description = group.documentSnapshot(forPath: "description").value as! String
//                    let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
//                    groupsArray.append(group)
//                }
//            }
//            handler(groupsArray)
//        }
//
    
    func testData() {
        let citiesRef = db.collection("cities")

        citiesRef.document("SF").setData([
            "name": "San Francisco",
            "state": "CA",
            "country": "USA",
            "capital": false,
            "population": 860000,
            "regions": ["west_coast", "norcal"]
            ])
        citiesRef.document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA",
            "capital": false,
            "population": 3900000,
            "regions": ["west_coast", "socal"]
            ])
        citiesRef.document("DC").setData([
            "name": "Washington D.C.",
            "country": "USA",
            "capital": true,
            "population": 680000,
            "regions": ["east_coast"]
            ])
        citiesRef.document("TOK").setData([
            "name": "Tokyo",
            "country": "Japan",
            "capital": true,
            "population": 9000000,
            "regions": ["kanto", "honshu"]
            ])
        citiesRef.document("BJ").setData([
            "name": "Beijing",
            "country": "China",
            "capital": true,
            "population": 21500000,
            "regions": ["jingjinji", "hebei"]
            ])

    }



    



