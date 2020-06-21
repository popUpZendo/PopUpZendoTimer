//
//  GroupsCreateVC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/15/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage



class GroupsCreateVC: UIViewController {
    
    @IBAction func groupNameField(_ sender: Any) {
    }
    
    
    
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var formatField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var inoField: UITextField!
    @IBOutlet weak var roshiField: UITextField!
    @IBOutlet weak var templeField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var zoomField: UITextField!
    @IBOutlet weak var logoButton: UIButton!
    
    let storageRef = Storage.storage().reference()
    let uid = (Auth.auth().currentUser?.uid)!
    let tempDate = Date()
    var groupDay = Date()
    var groupTime = Date()
    var weekday = ""
    var groupHour = ""
    var userName = ""
    //let imagePicker = UIImagePickerController()
    var bannerImageURL = "Image String"
    var logoImageURL = "Logo String"
    var imagePicker: ImagePicker!
    var selectedButton = "banner"
    var ImageURL = "ImageURL"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
                 self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
               self.timeField.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
               // imagePicker.delegate = self
        getUserName()
    }
    
    
    
//      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//          var selectedImageFromPicker: UIImage?
//
//          if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
//              selectedImageFromPicker = editedImage.resizeWithWidth(width: 200)!
//          }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
//              selectedImageFromPicker = originalImage.resizeWithWidth(width: 200)!
//          }
//          if let selectedImage = selectedImageFromPicker{
//              banner.image = selectedImage
//          }
//          dismiss(animated: true, completion: nil)
//      }
//      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//          dismiss(animated: true, completion: nil)
//      }
    
    func uploadImage(pic: UIImageView, imageURL: String) -> (String) {
         
        var imageURL = imageURL
        //var addURLto = imageURL
        
        func addURL() {
            if pic == logo {
                logoImageURL = imageURL
                print("Updated logoImageURL \(logoImageURL)")
            } else {
                bannerImageURL = imageURL
            }
        }
         let imageName = NSUUID().uuidString
         
         let storedImage = storageRef.child("banner_images").child(imageName)
         
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
            
             //print("Temple Image: \(bannerImage)")
            
         }
         return imageURL
    }
    
    
//    func stringFromDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
//        return formatter.string(from: date)
//    }

  @objc func tapDone() {
        if let datePicker = self.timeField.inputView as? UIDatePicker {
            groupTime = datePicker.date
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "EEEE's  at ' h:mm a"
            self.timeField.text = dateformatter.string(from: datePicker.date) //2-4
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            let groupHourFormatter = DateFormatter()
            groupHourFormatter.dateFormat = "h:mm a"
            self.weekday = weekdayFormatter.string(from: datePicker.date)
            self.groupHour = groupHourFormatter.string(from: datePicker.date)
            
            
            //scheduleNotification()
            
            
        }
    self.timeField.resignFirstResponder()
          
          //clearButton.isHidden = false
          //datePassed()
      }
    
    
    func uploadGroup () {
              let uid = (Auth.auth().currentUser?.uid)!
          if groupNameField.text != nil && cityField.text != nil {
            DataService.instance.createGroup(withGroupName: groupNameField.text!, withWeekday: weekday, withTime: groupHour, withFormat: formatField.text!, withDetails: detailsField.text!, withCity: cityField.text!, withIno: userName, withRoshi: roshiField.text!, withWebsite: websiteField.text!, withZoom: zoomField.text!, withTemple: templeField.text!, withPic: bannerImageURL, withLogo: logoImageURL, withMembers: [userName], withSenderID: uid, forUID: uid, withBodhiKey: nil, sendComplete: { (isComplete) in
                          if isComplete {
          //                self.sendBtn.isEnabled = true
          //                self.dismiss(animated: true, completion: nil)
                          } else {
          //                self.sendBtn.isEnabled = true
                          print("There was an error!")
                          }
                          })
                  }
      }
    @IBAction func showImagePicker(_ sender: UIButton) {
        selectedButton = "banner"
         self.imagePicker.present(from: sender)
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
    
    @IBAction func profileWasTapped2(_ sender: Any)
       {
//           imagePicker.allowsEditing = false
//           imagePicker.sourceType = .photoLibrary
//
//           present(imagePicker, animated: true, completion: nil)
        
       }
    
    @IBAction func showLogoPicker(_ sender: UIButton) {
        selectedButton = "logo"
        self.imagePicker.present(from: logoButton)
        print(sender.tag)
    }
    
    func uploadAllmages(completion: (_ success: Bool) -> Void) {
    uploadImage(pic: banner, imageURL: bannerImageURL)
    uploadImage(pic: logo, imageURL: logoImageURL)
        print(logoImageURL)
    completion(true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        uploadGroup()
      
    
    }


}

extension GroupsCreateVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        //self.banner.image = image
        
        if selectedButton == "logo" {
            self.logo.image = image
            uploadImage(pic: logo, imageURL: logoImageURL) 
           
            print("LogoURL \(logoImageURL)")
        } else {
        self.banner.image = image
            uploadImage(pic: banner, imageURL: bannerImageURL)
    }
}
}

//extension UIImage {
//    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
//        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = self
//        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        imageView.layer.render(in: context)
//        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
//        UIGraphicsEndImageContext()
//        return result
//    }
//    func resizeWithWidth(width: CGFloat) -> UIImage? {
//        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = self
//        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//        imageView.layer.render(in: context)
//        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
//        UIGraphicsEndImageContext()
//        return result
//    }
//}
