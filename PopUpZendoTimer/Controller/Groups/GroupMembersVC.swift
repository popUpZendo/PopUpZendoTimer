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
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var templeLabel: UILabel!
    @IBOutlet weak var inoLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedGroup = ""
    var members = [""]
    let storageRef = Storage.storage().reference()
    let uid = (Auth.auth().currentUser?.uid)!
    let tempDate = Date()
    var groupDay = Date()
    var groupTime = Date()
    var weekday = ""
    var userName = ""
    //let imagePicker = UIImagePickerController()
    var bannerImageURL = "Image String"
    var logoImageURL = "Logo String"
    var imagePicker: ImagePicker!
    var selectedButton = "banner"
    var ImageURL = "ImageURL"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getOneGroup()
        // Do any additional setup after loading the view.
    }
    
    
    
    func getOneGroup () {
        db.collection("groups").document("Practical Zen")
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          guard let data = document.data() else {
            print("Document data was empty.")
            return
          }
         // print("Current data: \(data)")
            let groupName = document.get("groupName") as! String
            print(groupName)
           // let city = document.get("city") as! String
            //let details = document.get("details") as! String
            //let weekday = document.get("weekday") as! String
            let timeStamp = document.get("time") as! Timestamp
            let time = timeStamp.dateValue()
            let ino  = document.get("ino") as! String
            let members = document.get("members") as! [String]
            //let roshi = document.get("roshi") as! String
            let temple = document.get("temple") as! String
            //let website = document.get("website") as! String
            //let zoom = document.get("zoom") as! String
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "EEEE's  at ' h:mm a"
            self.timeLabel.text = dateformatter.string(from: time)
            self.groupNameLabel.text = groupName
            self.members = members
            //self.cityField.text = city
            //self.detailsField.text = details
            //self.roshiLabel.text = roshi
            self.inoLabel.text = ino
            self.templeLabel.text = temple
            // self.websiteField.text = website
            //self.weekdayLabel.text = weekday
            // self.zoomField.text = zoom
            //self.weekdayField.text = weekday
            
        
         //self.membersLabel.text = members.joined(separator: " ")
            //self.groupLable.text = String(describing: (groups))
        }
    }

    
}


extension GroupMembersVC:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath)
        let member = members[indexPath.row]
        cell.textLabel?.text = member

        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectedGroup = groups[indexPath.row]
//        performSegue(withIdentifier: "goToGroupMembersVC", sender: self)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let GroupMembersVC = segue.destination as? GroupMembersVC {
//            GroupMembersVC.selectedGroup = self.selectedGroup
//        }
//    }

}
