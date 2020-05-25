//
//  GroupsVC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/3/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase

class GroupsVCTest: UIViewController {
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var inoLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var cityField: UITextField!
   
    
    let uid = (Auth.auth().currentUser?.uid)!
    let tempDate = Date()
    var groupDay = Date()
    var groupTime = Date()
    var weekday = ""
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timeField.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
        getOneGroup()
        getUserName()
        DataService.instance.getAllGroups { (returnedGroupsArray) in
        print("Returned Groups Array : \(returnedGroupsArray)")

        //print("returnedGroupsArray \(groups.memberArray)")
        }

    }
//    //=============THIS IS AN EXACT COPY OF WHAT WORKED AT ONE POINT=======
//db.collection("groups")
//           .addSnapshotListener { querySnapshot, error in
//               guard let documents = querySnapshot?.documents else {
//                   print("Error fetching documents: \(error!)")
//                   return
//               }
//               let groupName = documents.map { $0["Group Name"]! }
//               let weekday = documents.map { $0["Weekday"]! }
//               let time = documents.map { $0["Time"]! }
//               let details = documents.map { $0["Details"]! }
//               let city = documents.map { $0["City"]! }
//               let ino = documents.map { $0["ino"]! }
//               let members = documents.map { $0["Members"]! }
//               let senderId = documents.map { $0["SenderId"]! }
//               print("Current cities in CA: \(groupName)")
//               print("Ino: \(ino)")
//               print("Time \(time)")
//           }
    
    func getGroups() {
        db.collection("groups")
                   .addSnapshotListener { querySnapshot, error in
                       guard let documents = querySnapshot?.documents else {
                           print("Error fetching documents: \(error!)")
                           return
                       }
                       let groupName = documents.map { $0["Group Name"]! }
                       let weekday = documents.map { $0["Weekday"]! }
                       let time = documents.map { $0["Time"]! }
                       let details = documents.map { $0["Details"]! }
                       let city = documents.map { $0["City"]! }
                       let ino = documents.map { $0["ino"]! }
                       let members = documents.map { $0["Members"]! }
                       let senderId = documents.map { $0["SenderId"]! }
                       print("Current cities in CA: \(groupName)")
                       print("Ino: \(ino)")
                       print("Time \(time)")
                   }
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
           let city = document.get("city") as! String
           let details = document.get("details") as! String
            let weekday = document.get("weekday") as! String
        let timeStamp = document.get("time") as! Timestamp
            let time = timeStamp.dateValue()
        let ino  = document.get("ino") as! String
        let members = document.get("members") as! [String]
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE's  at ' h:mm a"
        self.timeLabel.text = dateformatter.string(from: time)
        self.groupLabel.text = groupName
        self.cityLabel.text = city
        self.detailsLabel.text = details
        self.weekdayLabel.text = weekday
        self.inoLabel.text = ino
        self.membersLabel.text = members.joined(separator: " ")
           //self.groupLable.text = String(describing: (groups))
       }
   }
    
    

    @objc func tapDone() {
        if let datePicker = self.timeField.inputView as? UIDatePicker {
            groupTime = datePicker.date
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "EEEE's  at ' h:mm a"
            self.timeField.text = dateformatter.string(from: datePicker.date) //2-4
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            self.weekday = weekdayFormatter.string(from: datePicker.date)


            //scheduleNotification()


        }
    self.timeField.resignFirstResponder()

          //clearButton.isHidden = false
          //datePassed()
      }
    
  func getUserName () {
    let docRef = db.collection("bodhi").document(uid)

    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            //print("Document data: \(dataDescription)")
        } else {
            print("Document does not exist")
        }
        
        self.userName = document?.get("Name") as! String
    }
        
    }
            
//    func uploadGroup () {
//            let uid = (Auth.auth().currentUser?.uid)!
//        if nameField.text != nil && cityField.text != nil {
//            DataService.instance.createGroup(withGroupName: nameField.text!, withWeekday: weekday, withTime: groupTime, withDetails: detailsField.text!, withCity: cityField.text!, withIno: userName, withMembers: [userName], withSenderID: uid, forUID: uid, withBodhiKey: nil, sendComplete: { (isComplete) in
//                        if isComplete {
//        //                self.sendBtn.isEnabled = true
//        //                self.dismiss(animated: true, completion: nil)
//                        } else {
//        //                self.sendBtn.isEnabled = true
//                        print("There was an error!")
//                        }
//                        })
//                }
//    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
       // uploadGroup()
    
    }
    @IBAction func middayToggle(_ sender: Any) {
    }
    

}
