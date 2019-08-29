//
//  Settings VC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 8/28/19.
//  Copyright © 2019 Joseph Hall. All rights reserved.
//

import UIKit

class Settings_VC: UIViewController {
    
    @IBOutlet weak var infoField: UITextView!
    @IBOutlet weak var bellSwitch: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    
    let defaults = UserDefaults.standard
    let mode = "mode"
    let bell = "bell"
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
        self.infoField.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
        self.infoField.backgroundColor = UIColor.white
    }
    
    func muteBell() {
        defaults.set(true, forKey: "bell")
        self.bellButton.setImage(UIImage(named: "bell-button-off"), for: .normal)
        print("Bell Muted")
    }
    
    func playBell() {
        defaults.set(false, forKey: "bell")
        self.bellButton.setImage(UIImage(named: "bell-button-2"), for: .normal)
        print("Bell Playing")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let setMode = defaults.bool(forKey: "mode")
        print("this is the \(mode)")
        
        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
        let setBell = defaults.bool(forKey: "bell")
        print(bell)
        
        if defaults.bool(forKey: "bell") == false {
            playBell()
        } else {
            muteBell()
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
    
    
    
    @IBAction func testButton(_ sender: Any) {
        print("Test Button Tapped")
        if defaults.bool(forKey: "bell") == false {
            muteBell()
        } else {
            playBell()
        }
    }
    
//bell-button-off
}
