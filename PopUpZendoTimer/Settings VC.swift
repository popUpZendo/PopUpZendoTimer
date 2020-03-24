//
//  Settings VC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 8/28/19.
//  Copyright © 2019 Joseph Hall. All rights reserved.
//

import UIKit

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
    
    
    //@IBOutlet weak var infoField: UITextView
    @IBOutlet weak var bellSwitch: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    
    let defaults = UserDefaults.standard
    let mode = "mode"
    let bell = "bell"
    
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
        
        hideTips()
        
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }

        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }

        //let setMode = defaults.bool(forKey: "mode")
        
        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
        //let setBell = defaults.bool(forKey: "bell")
        
        if defaults.bool(forKey: "bell") == true {
            playBell()
        } else {
            muteBell()
        }
        
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
    
    
    
    @IBAction func muteBellButton(_ sender: Any) {
        if defaults.bool(forKey: "bell") == true {
            muteBell()
        } else {
            playBell()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}
