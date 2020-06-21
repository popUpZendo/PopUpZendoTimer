//
//  FirebaseInterface.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/28/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import Foundation
import Firebase

class FirebaseInterface {
    static let instance = FirebaseInterface()
    
    var groups: [Group]?
    var bodhi: [String: Bodhi] = [:]
    
    struct Notifications {
        static let groupsChanged = Notification.Name("groups-changed")
        static let bodhiChanged = Notification.Name("bodhi-changed")
    }
    
    func setup() {
        
    }
    
    func fetchBodhiByID(ids: [String], completion: @escaping ([Bodhi]) -> Void) {
        var cached: [Bodhi] = []
        var remainingIDs: [String] = []
        
        for id in ids {
            if let bodhi = self.bodhi[id] {
                cached.append(bodhi)
            } else {
                remainingIDs.append(id)
            }
        }
        if remainingIDs.isEmpty { completion(cached); return }
        
        var group: DispatchGroup? = DispatchGroup()
        for id in remainingIDs {
            group?.enter()
            Firestore.firestore().collection("bodhi").document(id).addSnapshotListener { snap, error in
                if let err = error {
                    print("Error when fetching Bodhi for id \(id): \(err)")
                }
                if let info = snap?.data(), let bodhi = Bodhi.load(from: info) {
                    cached.append(bodhi)
                    self.bodhi[id] = bodhi
                }
                group?.leave()
            }
        }
        
        group?.notify(queue: .main) {
            group = nil
            completion(cached)
        }
    }
    
    
    init() {
        self.fetchGroups { _ in
            
        }
    }
    
    func fetchGroups(completion: @escaping ([Group]) -> Void) {
        let db = Firestore.firestore()
        if let groups = self.groups {
            completion(groups)
            return
        }
        
        db.collection("groups").addSnapshotListener { snapshot, error in
            if let documents = snapshot?.documents {
                for document in documents {
                    if let group = Group.load(from: document.data()) {
                        if let index = self.groups?.firstIndex(of: group) {
                            self.groups?[index] = group
                        } else {
                            if self.groups == nil { self.groups = [] }
                            self.groups?.append(group)
                        }
                    }
                }
                
                completion(self.groups ?? [])
                NotificationCenter.default.post(name: Notifications.groupsChanged, object: nil)
            }
        }
        
/*        db.collection("bodhi").addSnapshotListener { snapshot, error in
            if let documents = snapshot?.documents {
                for document in documents {
                    if let bodhi = Bodhi.load(from: document.data()) {
                        if let index = self.bodhi.firstIndex(of: bodhi) {
                            self.bodhi[index] = bodhi
                        } else {
                            self.bodhi.append(bodhi)
                        }
                    }
                }
                
                NotificationCenter.default.post(name: Notifications.bodhiChanged, object: nil)
            }
        }*/
    }
}
