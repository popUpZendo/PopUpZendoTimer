//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import FoldingCell
import UIKit
import FirebaseStorage
import Firebase

//let storage = Storage.storage()
var zoomLink = ""



class DemoCell: FoldingCell {

    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var temple: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var ino: UILabel!
    @IBOutlet weak var website: UIButton!
    @IBOutlet weak var roshi: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var zoom: UIButton!
    @IBOutlet weak var join: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weekday: UILabel!
    @IBOutlet weak var weekdayAbr: UILabel!
    @IBOutlet weak var groupName2: UILabel!
    @IBOutlet weak var temple2: UILabel!
    @IBOutlet weak var city2: UILabel!
    @IBOutlet weak var banner: UIImageView!
    
   var websiteURL = "google.com"
   var memberArray = [""]
    
    func configureCell(title: String, temple: String, city: String, ino: String, roshi: String, website: String, details: String, weekday: String, logo: String, banner: String, members: [String], zoom: String) {
        groupName.text = title
        self.temple.text = temple
        self.temple2.text = temple
        self.city.text = city
        self.city2.text = city
        self.ino.text = ino
        self.roshi.text = roshi
        self.website.setTitle(website, for:.normal)
        self.details.text = details
        //self.time.text = time
        self.weekday.text = weekday
        let abr = String(weekday.prefix(3))
        self.weekdayAbr.text = abr
        self.groupName2.text = title
        getLogoImage(imageURL: logo)
        getBannerImage(imageURL: banner)
        let zoomLink = "https://zoom.us/j/\(zoom))"
        self.websiteURL = website
        self.memberArray = members
        if memberArray.contains(uid) {
            self.join.setTitle("Member", for: .normal)
            self.join.setBackgroundColor(color: UIColor.white, forState: .normal)
        }
        printMemberArray()
//        let bannerImage: UIImage = getBannerImage(imageURL: banner)
//        self.banner.image = bannerImage
    }
    
//    var number: Int = 0 {
//        didSet {
//            closeNumberLabel.text = String(number)
//            openNumberLabel.text = String(number)
//        }
//    }
    func printMemberArray () {
        print("MemberArray========= \(memberArray)")
    }
    
    
    func getBannerImage (imageURL: String) -> UIImage{
       let httpsReference = storage.reference(forURL: imageURL)
        var bannerImage = UIImage(named: "small-bell")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        httpsReference.getData(maxSize: 3 * 1024 * 1024) { data, error in
          if let error = error {
            print("Uh-oh, an error occurred!")
          } else {
            print("Image is returned")
            // Data for "images/island.jpg" is returned
            bannerImage = UIImage(data: data!)!
            self.banner.image = bannerImage
          }
          
        }
        return bannerImage!
    }
    
    func getLogoImage (imageURL: String) -> UIImage{
       let httpsReference = storage.reference(forURL: imageURL)
        var logoImage = UIImage(named: "small-bell")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        httpsReference.getData(maxSize: 3 * 1024 * 1024) { data, error in
          if let error = error {
            print("Uh-oh, an error occurred!")
          } else {
            print("Image is returned")
            // Data for "images/island.jpg" is returned
            logoImage = UIImage(data: data!)!
            self.logo.image = logoImage
          }
          
        }
        return logoImage!
    }
    
    func joinGroup(groupName: String) {
        DataService.instance.selectGroup(withName: groupName, withSenderID: uid, forUID: uid, withBodhiKey: nil, sendComplete: { (isComplete) in
            if isComplete {
                //                self.sendBtn.isEnabled = true
                //                self.dismiss(animated: true, completion: nil)
            } else {
                //                self.sendBtn.isEnabled = true
                print("There was an error!")
            }
        })
    }

    func leaveGroup(groupName: String) {
       DataService.instance.leaveGroup(withName: groupName, withSenderID: uid, forUID: uid, withBodhiKey: nil, sendComplete: { (isComplete) in
            if isComplete {
                //                self.sendBtn.isEnabled = true
                //                self.dismiss(animated: true, completion: nil)
            } else {
                //                self.sendBtn.isEnabled = true
                print("There was an error!")
            }
        })
    }
    
    

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }

    
   
    
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    @IBAction func websiteButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://\(websiteURL)") {
            UIApplication.shared.open(url)
        }
    }
    
    
    
}



// MARK: - Actions ⚡️

extension DemoCell {

    @IBAction func buttonHandler(_: AnyObject) {
        if self.join.titleLabel?.text == "Join" {
        joinGroup(groupName: groupName.text ?? "error")
        self.join.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.join.setTitle("Member", for: .normal)
        } else {
            leaveGroup(groupName: groupName.text ?? "error")
            self.join.setBackgroundColor(color: UIColor(red:0.37, green:0.37, blue:0.35, alpha:1.00), forState: .normal)
            self.join.setTitle("Join", for: .normal)
        }
        
    }
    
    @IBAction func zoomButtonTapped(_: AnyObject) {
        print("tap")
        if let url = URL(string: "https://zoom.us/j/5372992960") {
        UIApplication.shared.open(url)
    }
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
    UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
}}



