//
//  Settings VC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 8/28/19.
//  Copyright © 2019 Joseph Hall. All rights reserved.
//

import UIKit
import AVFoundation

class Settings_VC: UIViewController {
    
    //Help Screen
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var infoTips: UILabel!
    @IBOutlet weak var GroupsHelp: UILabel!
    @IBOutlet weak var SupportTips: UILabel!
    @IBOutlet weak var atartTips: UILabel!
    @IBOutlet weak var bellTip: UILabel!
    @IBOutlet weak var endTip: UILabel!
    @IBOutlet weak var muteTip: UILabel!
    @IBOutlet weak var delayTip: UILabel!
    @IBOutlet weak var modeTip: UILabel!
    @IBOutlet weak var hanTip: UILabel!
    
    
    //@IBOutlet weak var infoField: UITextView
    @IBOutlet weak var bellSwitch: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var countdownField: UITextField!
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var bellTypeButton: UIButton!
    @IBOutlet weak var hanButton: UIButton!
    
    let defaults = UserDefaults.standard
    let mode = "mode"
    let bell = "bell"
    let countdownNumber = "4"
    let startNumber = "3"
    let endNumber = "1"
    var doan: Doan!
    
    


    
    func showTips () {
        instructions.isHidden = false
        infoTips.isHidden = false
        GroupsHelp.isHidden = false
        SupportTips.isHidden = false
        atartTips.isHidden = false
        bellTip.isHidden = false
        endTip.isHidden = false
        muteTip.isHidden = false
        delayTip.isHidden = false
        modeTip.isHidden = false
        hanTip.isHidden = false
    }
    
    func hideTips () {
        instructions.isHidden = true
        infoTips.isHidden = true
        GroupsHelp.isHidden = true
        SupportTips.isHidden = true
        atartTips.isHidden = true
        bellTip.isHidden = true
        endTip.isHidden = true
        muteTip.isHidden = true
        delayTip.isHidden = true
        modeTip.isHidden = true
        hanTip.isHidden = true
    }
    
    
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
        ////self.infoField.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
       // self.infoField.backgroundColor = UIColor.white
    }
    
    func muteBell() {
        defaults.set(false, forKey: "bell")
        self.bellButton.setImage(UIImage(named: "mute-button-on"), for: .normal)
    }
    
    func playBell() {
        defaults.set(true, forKey: "bell")
        self.bellButton.setImage(UIImage(named: "mute-button-off"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doan = Doan.instance
        
        hideTips()
        countdownField.text = countdownNumber
        startField.text = startNumber
        endField.text = endNumber
        hanButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        
        
        
        
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if defaults.bool(forKey: "mode") == true {
                darkMode()
            } else {
                lightMode()
            }
        print("User Defaults Mode: \(mode)")
            
            //let setBell = defaults.bool(forKey: "bell")
            //let setMode = defaults.bool(forKey: "mode")
            
            if defaults.bool(forKey: "bell") == true {
                playBell()
            } else {
                muteBell()
            }
        startField.text = defaults.string(forKey: "startNumber")
        endField.text = defaults.string(forKey: "endNumber")
        countdownField.text = defaults.string(forKey: "countdownNumber")
        
        let bellImage = defaults.string(forKey: "bellImage")
        self.bellTypeButton.setImage(UIImage(named: bellImage!), for: .normal)
        
//        func textFieldDidBeginEditing(textField: UITextField) {
//            if (textField == startField) {
//               startField.text = ""
//            } else if (textField == endField) {
//               endField.text = ""
//            } else if (textField == countdownField) {
//            countdownField.text = ""
//            }
//        }
        
        }

        @objc func keyboardWillShow(notification: NSNotification) {
//            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y == 0 {
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
//            }
        }
    
    

    func saveNumbers (){
        if startField.text != "" {
            defaults.set(startField.text, forKey: "startNumber")
            print("Start Number Defaults to \(String(describing: defaults.value(forKey: "startNumber")))")
        } else {
            startField.text = defaults.value(forKey: "startNumber") as? String}
        if endField.text != "" {
            defaults.set(endField.text, forKey: "endNumber")
            print("End Number Defaults to \(String(describing: defaults.value(forKey: "endNumber")))")
        } else {
        endField.text = defaults.value(forKey: "endNumber") as? String}
        if countdownField.text != "" {
            defaults.set(countdownField.text, forKey: "countdownNumber")
            print("Countdown Number Defaults to \(String(describing: defaults.value(forKey: "countdownNumber")))")
        } else {
        countdownField.text = defaults.value(forKey: "countdownNumber") as? String}
    }
    
        @objc func keyboardWillHide(notification: NSNotification) {
//            if self.view.frame.origin.y != 0 {
//                self.view.frame.origin.y = 0
                saveNumbers()
                
                
//            }
    }

      

    
    
    @IBAction func instructionsPopup(_ sender: Any) {
        if instructions.isHidden == true {
            showTips()
        } else {
            hideTips()
        }
    }
    
    @IBAction func groupsButton(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! InstructionsVC
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    
    @IBAction func websiteButton(_ sender: Any) {
        if let url = URL(string: "https://popupzendo.org/app") {
            UIApplication.shared.open(url)
        }
    }
    
    
    
    
    @IBAction func darkModeButtonTapped(_ sender: Any) {
        if self.view.backgroundColor != UIColor.black{
            darkMode()
            defaults.set(true, forKey: "mode")

        } else {
            lightMode()
            defaults.set(false, forKey: "mode")
        }
    }
    
    
    @IBAction func starNumberButton(_ sender: Any) {
        
    }
    
    //---------  Bell Selection----------------------------------------------------------
    let smallBell = Bells.smallBell
    let mediumKesu = Bells.mediumKesu
    let largeKesu = Bells.largeKesu
    
    func selectSmallBell () {
        defaults.set(smallBell.image, forKey: "bellImage")
        defaults.set(smallBell.sound, forKey: "bellSound")
        defaults.set(smallBell.ext, forKey: "ext")
        self.bellTypeButton.setImage(UIImage(named: smallBell.image), for: .normal)
        //doan.bell.stop()
        doan.testBell(name: "small-bell")
    }
    
    func selectMediumKesu () {
        defaults.set(mediumKesu.image, forKey: "bellImage")
        defaults.set(mediumKesu.sound, forKey: "bellSound")
        defaults.set(mediumKesu.ext, forKey: "ext")
        self.bellTypeButton.setImage(UIImage(named: mediumKesu.image), for: .normal)
        //doan.bell.stop()
        doan.testBell(name: "medium-kesu")
        
    }
    
    func selectLargeKesu () {
        defaults.set(largeKesu.image, forKey: "bellImage")
        defaults.set(largeKesu.sound, forKey: "bellSound")
        defaults.set(largeKesu.ext, forKey: "ext")
        self.bellTypeButton.setImage(UIImage(named: largeKesu.image), for: .normal)
        //doan.bell.stop()
        doan.testBell(name: "large-kesu")
    }
    
    
    
    @IBAction func bellTypeButtonTapped(_ sender: Any) {
        
        if bellTypeButton.currentImage == UIImage(named: smallBell.image)  {
            selectMediumKesu()
        } else if bellTypeButton.currentImage == UIImage(named: mediumKesu.image) {
            selectLargeKesu()
        } else if bellTypeButton.currentImage == UIImage(named: largeKesu.image) {
            selectSmallBell()
        }
    }
    
    //-----------------------------------------------------------------------------------
    
    @IBAction func muteBellButton(_ sender: Any) {
        if defaults.bool(forKey: "bell") == true {
            muteBell()
        } else {
            playBell()
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       if let text = self.startField.text, let value = Int(text) {
//           defaults.setValue(value, forKeyPath: startNumber)
//           //startField.text = "5"
//       }
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}
