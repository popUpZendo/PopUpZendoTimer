//
//  Han VC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/3/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import AVFoundation

class Han_VC: UIViewController {
    
    let defaults = UserDefaults.standard
    let mode = "mode"
    let bell = "bell"
    var hanMute = true
    var hanSound: AVAudioPlayer!
    
    
    @IBOutlet weak var han: UIButton!
    @IBOutlet weak var scheduleTitleField: UILabel!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "hanMute")  == true{
        hanMute = true
        } else {
        hanMute = false
        }
        
        scheduleTitleField.text = "No han is scheduled"
        
        self.dateField.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
        
        
        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
        if defaults.object(forKey: "hanTime") != nil {
        let date = defaults.object(forKey: "hanTime") as! Date
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium // 2-3
        dateformatter.timeStyle = .short
        dateField.text = dateformatter.string(from: date)
        //datePassed ()
        }
        
        if dateField.text == "Schedule Han" {
            clearButton.isHidden = true
            scheduleTitleField.text = "No han is scheduled"
        } else {
            clearButton.isHidden = false
            scheduleTitleField.text = "The han is scheduled for"
        }
        
        
        
        

        
//        let hanSound = (defaults.string(forKey: "hanSound"))!
        
        let path = Bundle.main.path(forResource: "han", ofType: "aiff")
            let soundURL = URL(fileURLWithPath: path!)

            do {
               try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }

            do {
                try hanSound = AVAudioPlayer(contentsOf: soundURL)
                hanSound.prepareToPlay()
            } catch let err as NSError {
                print(err.debugDescription)
                
        }
        
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        dateField.text = "Schedule Han"
        clearButton.isHidden = true
        scheduleTitleField.text = "No han is scheduled"
        UserDefaults.standard.set(Date(timeIntervalSinceReferenceDate: -12345.0), forKey: "hanDate")
    }
    
    @IBAction func muteButtonPressed(_ sender: Any) {
        if hanMute == true {
            unMuteHan()
        } else if hanMute == false {
            muteHan()
        }
    }
    
    
    
    @IBAction func hanButton(_ sender: Any) {
        
        
        playHanSound()
    }

    func muteHan() {
        self.hanSound.stop()
        hanMute = true
        defaults.set(true, forKey: "hanMute")
        muteButton.setImage(UIImage(named: "mute-button-on"), for: .normal)
        print("Han is Muted")
        print(defaults.bool(forKey: "hanMute"))
    }
    
    func unMuteHan() {
        hanMute = false
        defaults.set(false, forKey: "hanMute")
        muteButton.setImage(UIImage(named: "mute-button-off"), for: .normal)
        print("The Han is unMuted")
        print(defaults.bool(forKey: "hanMute"))
    }
    
    func playHanSound() {
        if self.hanSound.isPlaying {
            self.hanSound.stop()
        } else {
           self.hanSound.currentTime = 0
            if hanMute != true {
           self.hanSound.play()
            }
       }
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.timeStyle = .short
            self.dateField.text = dateformatter.string(from: datePicker.date) //2-4
            clearButton.isHidden = false
            scheduleTitleField.text = "The han is scheduled for"
            UserDefaults.standard.set(Date(), forKey: "hanDate")
            //datePassed()
        }
        self.dateField.resignFirstResponder() // 2-5
        clearButton.isHidden = false
    }

    func datePassed () {
        let currentTime = Date()
        
        if defaults.object(forKey: "hanTime") != nil {
            let date = defaults.object(forKey: "hanTime") as! Date
            if date < currentTime {
                dateField.text = "Schedule Han"
                clearButton.isHidden = true
                scheduleTitleField.text = "No han is scheduled"
            }
            }
        
    }

}
