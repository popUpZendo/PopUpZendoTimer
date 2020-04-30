//
//  Han VC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/3/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class HanVC: UIViewController, UNUserNotificationCenterDelegate {
    
    let defaults = UserDefaults.standard
    let mode = "mode"
    let bell = "bell"
    
    
    var hanCount = 0
    var components = DateComponents()
    var doan: Doan!
    weak var hanTimer: Timer?
    var timeRemaining = 0
    
    var minutes = 15
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
     //**************Tips*********************

    
    @IBOutlet weak var tipsHan: UILabel!
    @IBOutlet weak var tipsQuestions: UIButton!
    
    
    
    
    @IBOutlet weak var han: UIButton!
    @IBOutlet weak var scheduleTitleField: UILabel!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
   
    
    
    
   
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doan = Doan.instance
        if doan.han.isPlaying == true {
            han.setImage(UIImage.init(named: "han-on"), for: UIControl.State.normal)
        }
        continueHan()
        
        activityLabel.isHidden = true
        tipsHan.isHidden = true

        tipsQuestions.isHidden = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        
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
        dateformatter.dateFormat = "MMM d - EEEE'  at ' h:mm a"
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
        
        let getTimeStamp = timeStamp(date: Date())
        print(getTimeStamp)

        
    }
    
    func timeStamp(date: Date)->String {

      let dateFormater = DateFormatter()
      dateFormater.locale = Locale(identifier: "en-US")
      dateFormater.setLocalizedDateFormatFromTemplate("EEE MMM d yyyy")

      return dateFormater.string(from: Date())
        
    }
   
    
    
    
    
    
    func getDateComponents (Date: Date) -> DateComponents {
        let date = Date
        let calendar = Calendar.current
        //calendar.timeZone = TimeZone(identifier: "UTC")!
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        return components
    }
    
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        dateField.text = "Schedule Han"
        clearButton.isHidden = true
        scheduleTitleField.text = "No han is scheduled"
        UserDefaults.standard.set(Date(timeIntervalSinceReferenceDate: -12345.0), forKey: "hanTime")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    @IBAction func infoButtonPressed(_ sender: Any) {
        showTips()
        print("showTips?")
    }
    
    @IBAction func questionsButtonPressed(_ sender: Any) {
        let popOverVC2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hanInfoVC") as! hanInfoVC
        self.addChild(popOverVC2)
        popOverVC2.view.frame = self.view.frame
        self.view.addSubview(popOverVC2.view)
        popOverVC2.didMove(toParent: self)
           }
    
    @IBAction func hanButton(_ sender: Any) {
        playHan()
    }

    
    func updateUI (_ han: Bool) {
        if han == true {
            scheduleTitleField.isHidden = true
            dateField.isHidden = true
            clearButton.isHidden = true
            playLabel.isHidden = false
            activityLabel.isHidden = false
            self.han.setImage(UIImage.init(named: "han-on"), for: UIControl.State.normal)
        } else {
            scheduleTitleField.isHidden = false
            dateField.isHidden = false
            clearButton.isHidden = false
            //backButton.isHidden = false
            playLabel.isHidden = true
            activityLabel.isHidden = true
            self.han.setImage(UIImage.init(named: "han-off"), for: UIControl.State.normal)
        }
    }
    
    func playHan() {
        if doan.han.isPlaying {
            doan.han.stop()
            timer.invalidate()
            updateUI(false)
           } else {
            continueHan()
            if hanCount > 0 && hanCount <= (15 * 60) {
                doan.han.currentTime = Double(hanCount)
                print("Current Time Active \(doan.han.currentTime)")
            } else {
                doan.han.currentTime = 0
            }
                updateUI(true)
                doan.han.stop()
                doan.han.play()
                runTimer()
          }
       }
    
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        minutes = (Int(doan.han.duration - doan.han.currentTime) / 60 + 2)
        minutes -= 1
        playLabel.text = "begins in \(minutes) minutes"
        print(minutes)
    }
    
    func continueHan() -> Int {
       let date = Date()
       let hanTime = UserDefaults.standard.object(forKey: "hanTime") as! Date
       let hanCount = Calendar.current.dateComponents([.second], from: date, to: hanTime).second!
        if hanCount > 0 && hanCount < (15 * 60){
            playLabel.isHidden = false
        } else {
            playLabel.isHidden = true
        }
        self.hanCount = hanCount
        return self.hanCount
    }
    
    
    
    
    @IBAction func SaveButton(_ sender: Any) {
        tapDone()
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMM d - EEEE'  at ' h:mm a"
            self.dateField.text = dateformatter.string(from: datePicker.date) //2-4
            clearButton.isHidden = false
            scheduleTitleField.text = "The han is scheduled for"
            UserDefaults.standard.set(datePicker.date, forKey: "hanTime")
            scheduleNotification()
            //datePassed()
        }
        self.dateField.resignFirstResponder()
        clearButton.isHidden = false
        datePassed()
    }
    
        func scheduleNotification() {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

            let center = UNUserNotificationCenter.current()
            let soundName = UNNotificationSoundName("han-intro.aiff")
            

            let content = UNMutableNotificationContent()
            content.title = "Miday Meditation is at 12pm"
            content.body = "Tap here if you would like the han to continue."
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.init(named: soundName)
            
            let hanTime = UserDefaults.standard.object(forKey: "hanTime") as! Date
            getDateComponents(Date: hanTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
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
    
    func showTips() {
        if tipsHan.isHidden == false {
            tipsHan.isHidden = true
            tipsQuestions.isHidden = true
        } else {
            tipsHan.isHidden = false
            tipsQuestions.isHidden = false
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

}
