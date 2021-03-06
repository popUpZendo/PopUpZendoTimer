//
//  ProfileVC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/3/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class ProfileVC: UIViewController {
  
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    let storageRef = Storage.storage().reference()
    var groupsArray = [""]
    
    // current user can be nil if user haven't logged in
    // use "String!" to store possible nil value, the "!" will auto force unwrap it when you use "uid"
    let uid : String! = Auth.auth().currentUser?.uid
    var isChecked = true
    var profileImageURL = "Profile String" 
    var imagePicker: ImagePicker!
    var selectedButton = "profileImage"
    var ImageURL = "ImageURL"
    
    
    let defaults = UserDefaults.standard
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
        ////self.infoField.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
       // self.infoField.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        //setupView()
       //readArray()
        readProfile()
        //getProfileImage(imageURL: profileImageURL)

    }
    

    
    func readProfile () {
        // ensure uid is not nil before proceeding to read profile
        guard let uid = uid else { return }
        
        DataService.instance.bodhi_collection.document(uid)
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
            //COMMENTED OUT TO SILENCE WARNING
//          guard let data = document.data() else {
//            print("Document data was empty.")
//            return
//          }
          //print("Current data: \(data)")
            let name = document.get("name") as! String
            let email = document.get("email") as! String
            let city = document.get("city") as! String
            let profileImageURL = document.get("pic") as! String
            
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            self.profileImage.clipsToBounds = true
            self.profileImageURL = profileImageURL
            self.getProfileImage(imageURL: profileImageURL)
            self.nameField.text = name
            self.emailField.text = email
            self.cityField.text = city
            //self.groupLable.text = String(describing: (groups))
        }
    }

    
    func setupView() {
        let docRef = DataService.instance.bodhi_collection.document(uid)
        var profile = ""
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
               // print("Document data: \(dataDescription)")
                profile = dataDescription
               // print("Profile: \(profile)")
                
                //self.nameField.text = profile.name
                //self.nameField.text = dataDescription["Name"]
            } else {
                print("Document does not exist")
            }
        }
        print(profile)
    }
    
    
    
    
    
    //@discardableResult
    func uploadImage(pic: UIImageView, imageURL: String) /*-> (String) */{
        
        var imageURL = imageURL
        //var addURLto = imageURL
        
        func addURL() {
            if pic == profileImage {
                profileImageURL = imageURL
                print("Updated profileImageURL \(profileImageURL)")
            } else {
                //DO SOMETHING
            }
        }
        let imageName = NSUUID().uuidString
        let storedImage = storageRef.child("profile_images").child(imageName)
        
        if let uploadData = pic.image!.pngData()
        {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    let urlText = url?.absoluteString
                    imageURL = urlText!
                    //print("Image URL \(imageURL)")
                    addURL()
                })
            })
        }
        //return imageURL
    }
    
    func uploadProfile () {
        if nameField.text != nil && emailField.text != nil && cityField.text != nil {
            DataService.instance.updateBodhi(withName: nameField.text!, withEmail: emailField.text!, withCity: cityField.text!, withPic: profileImageURL, withSenderID: uid, forUID: uid, withBodhiKey: nil, sendComplete: { (isComplete) in
                if isComplete {
//
                } else {
//                
                print("There was an error!")
                }
                })
            readProfile()
            
        }
        }
    
    func getProfileImage (imageURL: String) {
        if profileImageURL == "" {
            self.profileImage.image = UIImage(named: "profile-zen")
        } else {
        let httpsReference = DataService.instance.storage.reference(forURL: imageURL)
        var profileImage = UIImage(named: "profile-zen")
        httpsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            print("Uh-oh, an error occurred! \(error)")
          } else {
            profileImage = UIImage(data: data!)!
            self.profileImage.image = profileImage
          }

        }
       // return profileImage!
        }
    }
    
    
    @IBAction func Save(_ sender: Any) {
        uploadImage(pic: profileImage, imageURL: ImageURL)
        uploadProfile()
    }
    
    
    @IBAction func imageTapped(_ sender: Any) {
    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
           selectedButton = "profileImage"
            self.imagePicker.present(from: sender)
       }
    

}


extension ProfileVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        //self.banner.image = image
            self.profileImage.image = image
            uploadImage(pic: profileImage, imageURL: profileImageURL)
            print("profileImageURL \(profileImageURL)")
}
}


