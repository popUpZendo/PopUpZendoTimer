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
    var doans: [Bodhi] = []
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
    var doanryo = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.sanghaArray = FirebaseInterface.instance.groups
        self.tableView.reloadData()
        print(bodhiArray.count)
        print("selected Group ======= \(selectedGroupArray)")
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
        self.sangha = self.sanghaArray?.first { $0.groupName.contains(selectedGroup) }
        guard let sangha = self.sangha else { return }
        FirebaseInterface.instance.fetchBodhiByID(ids: sangha.members) { bodhi in
            self.members = bodhi
            self.doanryo = sangha.doans
            self.tableView.reloadData()
            
        }
        
        
        groupNameLabel.text = sangha.groupName
        timeLabel.text = "\(sangha.weekday)'s at \(sangha.time)"
        templeLabel.text = sangha.temple
        inoLabel.text = sangha.ino
    }
   
}


extension GroupMembersVC:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath) as! membersCell
        let member = members[indexPath.row]
        
        
        if doanryo.contains(member.senderId) {
            member.doan = true
        } else {
            member.doan = false
        }
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
        let cell = tableView.cellForRow(at: indexPath) as! membersCell
        let member = members[indexPath.row]
        
        func toggleDoan() {
              if member.doan == true {
                member.doan = false
                self.doanryo = doanryo.filter { $0 != member.senderId}
                cell.doanButton.isHidden = true
                print("Doan Removed: doanryo is now \(doanryo)")
                
              } else {
                member.doan = true
                self.doanryo.append(member.senderId)
                cell.doanButton.isHidden = false
                print("Doan added: doanryo is now \(doanryo)")
            }
            sangha?.doans = doanryo
            sangha?.save()
          }
        
        // 1
        let doanAction = UITableViewRowAction(style: .normal, title: "Doan" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
           
            
        // 2
        var dialogueMessage = "Do you want this person to ring bells for the entire group?"
            if self.doanryo.contains(member.senderId) {
                dialogueMessage = "Would you like to remove this person from the doanryo?  They will no longer be able to ring bells for the entire group"
            }
            
        let dialogue = UIAlertController(title: nil, message: dialogueMessage, preferredStyle: .actionSheet)
                
            let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                print("yes tapped")
                toggleDoan()
                cell.nameLabel.textColor = .darkGray
                tableView.reloadData()
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
        dialogue.addAction(confirmAction)
        dialogue.addAction(cancelAction)
                
        self.present(dialogue, animated: true, completion: nil)
        })
        // 3
        
        // 5
        return [doanAction]
    }

 

}
