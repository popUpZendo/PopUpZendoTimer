//
//  GroupMembersVC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/26/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class GroupMembersVC: UIViewController {
    var bodhiArray = [Bodhi]()
    var sanghaArray: [Group]?
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var templeLabel: UILabel!
    @IBOutlet weak var inoLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedGroup = ""
    var selectedGroupArray = [Group]()
    var members: [Bodhi] = []
    var memberNames = [""]
    let storageRef = Storage.storage().reference()
    let uid = (Auth.auth().currentUser?.uid)!
    let tempDate = Date()
    var groupDay = Date()
    var groupTime = Date()
    var weekday = ""
    var userName = ""
    var newTime = ""
    var bannerImageURL = "Image String"
    var logoImageURL = "Logo String"
    var imagePicker: ImagePicker!
    var selectedButton = "banner"
    var ImageURL = "ImageURL"
    var sangha: Group?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.sanghaArray = FirebaseInterface.instance.groups
        self.tableView.reloadData()
      //  print("sanghaArray ======= \(sanghaArray)")
       // print("bodhiArray \(bodhiArray)")
        print(bodhiArray.count)
//        if bodhiArray.contains("Joe Hall") {
//
//        }

        print("selected Group ======= \(selectedGroupArray)")
        
        //getOneGroup()
        setUpGroup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(groupsChanged), name: FirebaseInterface.Notifications.groupsChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(bodhiChanged), name: FirebaseInterface.Notifications.bodhiChanged, object: nil)
    }
    
    @objc func groupsChanged() {
         sanghaArray = FirebaseInterface.instance.groups
         self.setUpGroup()
     }
    
    @objc func bodhiChanged() {
      //  bodhiArray = FirebaseInterface.instance.bodhi
        self.tableView.reloadData()
    }
    
    
    func setUpGroup () {
//      let name = "Joe Hall"
//      if bodhiArray.contains(where: { bodhi in bodhi.name == name }) {
//          print("Found it!!!") } else {
//          print("Not Yet")
//      print("bodhiArray +++++++++++++++++ \(bodhiArray)")
//      }
        self.sangha = self.sanghaArray?.first { $0.groupName.contains(selectedGroup) }
        guard let sangha = self.sangha else { return }
        FirebaseInterface.instance.fetchBodhiByID(ids: sangha.members) { bodhi in
            self.members = bodhi
            self.tableView.reloadData()
            
        }
        groupNameLabel.text = sangha.groupName
        timeLabel.text = "\(sangha.weekday)'s at \(sangha.time)"
        templeLabel.text = sangha.temple
        inoLabel.text = sangha.ino
    }
    
//    func getOneGroup () {
//        db.collection("groups").document(selectedGroup)
//        .addSnapshotListener { documentSnapshot, error in
//          guard let document = documentSnapshot else {
//            print("Error fetching document: \(error!)")
//            return
//          }
//          guard let data = document.data() else {
//            print("Document data was empty.")
//            return
//          }
//            let groupName = document.get("groupName") as! String
//            //print(groupName)
//            let newTime = document.get("newTime") as! String
//            let ino = document.get("ino") as! String
//            let members = document.get("members") as! [String]
//            print(members)
//            let temple = document.get("temple") as! String
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = "EEEE's  at ' h:mm a"
//            //self.timeLabel.text = dateformatter.string(from: time)
//            self.timeLabel.text = newTime
//            self.groupNameLabel.text = groupName
//            self.members = members
//            self.inoLabel.text = ino
//            self.templeLabel.text = temple
//            self.getDetails(memberArray: members)
//
//        }
//    }
    
    func getDetails(memberArray: [String]) {
       //for member in memberArray {
            DataService.instance.getProfileInfo(forUID: "KlsbGPexTOSlZGcpySKF0R7P09l2")
            memberNames.append(userName)
    }
   
}


extension GroupMembersVC:  UITableViewDelegate, UITableViewDataSource {
    
    //    func toggleDoan() {
               //        if doanButton.isHidden == true {
               //            doanButton.isHidden = false
               //        } else {
               //            doanButton.isHidden = true
               //        }
               //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! membersCell
        let member = members[indexPath.row]
        //cell.textLabel?.text = member
        cell.configureCell(bodhi: member)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.selectedGroup = groups[indexPath.row]
//        performSegue(withIdentifier: "goToGroupMembersVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        // 1
        let doanAction = UITableViewRowAction(style: .normal, title: "Doan" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
           
            
        // 2
        let dialogue = UIAlertController(title: nil, message: "Do you want this person to ring bells for the entire group?", preferredStyle: .actionSheet)
                
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
        dialogue.addAction(confirmAction)
        dialogue.addAction(cancelAction)
                
        self.present(dialogue, animated: true, completion: nil)
        })
        // 3
        
        // 5
        return [doanAction]
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let GroupMembersVC = segue.destination as? GroupMembersVC {
//            GroupMembersVC.selectedGroup = self.selectedGroup
//        }
//    }

}
