////
////  GroupsListVC.swift
////  PopUpZendoTimer
////
////  Created by Joseph Hall on 5/9/20.
////  Copyright © 2020 Joseph Hall. All rights reserved.
////

import UIKit
import Firebase




class GroupsListVC: UIViewController {
    

        @IBOutlet weak var groupsTableView: UITableView!
        
        @IBOutlet weak var menuBtn: UIButton!
        var sanghaArray = [Group]()
        var groupFriendsArray = [String]()
        var oneSignalArray = [String]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
                  
                  groupsTableView.delegate = self
                  groupsTableView.dataSource = self
                  
                  //getGroupMembers ()
              }
            
       
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            //DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedSanghaArray) in
                self.sanghaArray = returnedSanghaArray
                self.groupsTableView.reloadData()
                print("returnedSangaArray \(self.sanghaArray)")
                }
            }
            
//            DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
//                DataService.instance.getAllGroupPlayerIds { (returnedGroupsArray) in
//                    self.groupFriendsArray = returnedGroupsArray
//                    self.groupsTableView.reloadData()
//                    print("groupFriendsArray \(self.groupFriendsArray)")
//                }
//            }
            
            
        }
        
        
    ////////////////Already Commented outt
    //    func getGroupMembers () {
    //    let ref = Database.database().reference(fromURL: "https://pop-up-zendo-d462d.firebaseio.com/")
    //    let userID = Auth.auth().currentUser?.uid
    //    let usersRef = ref.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
    //        print(snapshot)
    //    })
    //
    //    }
        
        
   // }
    extension GroupsListVC: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sanghaArray.count
           
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else {return UITableViewCell()}
               let group = sanghaArray[indexPath.row]
               cell.configureCell(title: group.groupName, description: group.ino, memberCount: 4)
               return cell
        }
        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else { return }
//            groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
//            presentDetail(groupFeedVC)
//        }

        
    }


