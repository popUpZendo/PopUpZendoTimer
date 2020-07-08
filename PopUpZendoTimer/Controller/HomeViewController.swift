//
//  HomeViewController.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/29/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase


extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            red: 1.0 / 255.0 * CGFloat(red),
            green: 1.0 / 255.0 * CGFloat(green),
            blue: 1.0 / 255.0 * CGFloat(blue),
            alpha: CGFloat(alpha))
    }
}

class HomeViewController: UIViewController, CircleMenuDelegate {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var groupslist: UILabel!
    
    var logoImage = UIImage(named: "zen-profile")
    var profileImageURL = ""
    var groups = [""]
    
    //var user: User!
   // let usersRef = db.collection("online")
    
    let defaults = UserDefaults.standard
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
        ////self.infoField.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
       // self.infoField.backgroundColor = UIColor.white
    }
    
    let items: [(icon: String, color: UIColor)] = [
        ("circle-timer", UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)),
          ("circle-profile", UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)),
          ("circle-groups", UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)),
          ("circle-bell", UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)),
          ("circle-temple", UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)),
        ("circle-settings", UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1))
      ]
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
//        Auth.auth().addStateDidChangeListener { auth, user in
//        guard let user = user else { return }
//          //self.user = User(authData: user)
//
//          // 1
//          let currentUserRef = self.usersRef.document(self.user.uid)
//          // 2
//          currentUserRef.setValue(uid, forKey: "online")
//          // 3
//          currentUserRef.onDisconnectRemoveValue()
        
        readProfile()
        
        
        
        //button.delegate = CircleMenuDelegate.self
        let midY = self.view.frame.height / 2
        let midX = self.view.frame.width / 2
        // add button
                let button = CircleMenu(
                    frame: CGRect(x: midX-20, y: midY/0.7, width: 50, height: 50),
                    normalIcon:"icon_menu",
                    selectedIcon:"icon_close",
                    buttonsCount: 6,
                    duration: 0.85,
                    distance: 120)
        button.backgroundColor = UIColor.lightGray
                button.delegate = self
                button.layer.cornerRadius = button.frame.size.width / 2.0
                view.addSubview(button)

        
        
        
        
    }
    
    func getProfileImage (imageURL: String) {
       let httpsReference = storage.reference(forURL: imageURL)
        var profileImage = UIImage(named: "profile-zen")
        httpsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            print("Uh-oh, an error occurred!")
          } else {
            profileImage = UIImage(data: data!)!
            self.profilePic.image = profileImage
          }
          
        }
       // return profileImage!
    }
    
    func readProfile () {
        guard let uid = uid else { return }
        db.collection("bodhi").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                //print("Current data: \(data)")
                let name = document.get("name") as! String
                let email = document.get("email") as! String
                let city = document.get("city") as! String
                let profileImageURL = document.get("pic") as! String
                let groups = document.get("groups") as! [String]
                let filteredGroups = groups.filter({ $0 != ""})
                
                self.profileImageURL = profileImageURL
                self.getProfileImage(imageURL: profileImageURL)
                self.username.text = name
                self.email.text = email
                self.city.text = city
                self.groupslist.text = filteredGroups.map { "\($0)" }.joined(separator:"\n")
                self.groups = groups
                if self.profilePic.image == UIImage(named: "zen-profile") {
                    self.profilePic.layer.cornerRadius = 0
                } else {
                    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
                    self.profilePic.clipsToBounds = true
                }
                
        }
    }
    
                
        // MARK: <CircleMenuDelegate>

          func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
              button.backgroundColor = items[atIndex].color

              button.setImage(UIImage(named: items[atIndex].icon), for: .normal)

              // set highlited image
              let highlightedImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
              button.setImage(highlightedImage, for: .highlighted)
              button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
          }

          func circleMenu(_: CircleMenu, buttonWillSelected _: UIButton, atIndex: Int) {
              print("button will selected: \(atIndex)")
          }

          func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
              print("button did selected: \(atIndex)")
            if atIndex == 0 {
            performSegue(withIdentifier: "backToZazen", sender: nil)
            } else if atIndex == 1 {
                performSegue(withIdentifier: "goToProfile", sender: nil)
            } else if  atIndex == 2 {
                performSegue(withIdentifier: "goToGroups", sender: nil)
            } else if atIndex == 3 {
                performSegue(withIdentifier: "goToBell", sender: nil)
            } else if atIndex == 4 {
                performSegue(withIdentifier: "goToSortGroups", sender: nil)
            } else if atIndex == 5 {
                performSegue(withIdentifier: "goToSettings", sender: nil)
            }
            
    }
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "backToZazen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let GroupsSortVC = segue.destination as? GroupsSortVC {
            GroupsSortVC.groups = groups.filter({ $0 != ""})
        } else {
        if let DoanStation = segue.destination as? DoanStation {
            DoanStation.groups = groups.filter({ $0 != ""})
        }
        }
    }
    
    
}

