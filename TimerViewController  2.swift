//
//  TimerViewController.swift
//  Pop Up Zendo Timer
//
//  Created by Joseph Hall on 9/1/19.
//  Copyright © 2019 Om Design. All rights reserved.
//

import UIKit
import AVFoundation
import KDCircularProgress


class TimerViewController: UIViewController {
    
    var progress: KDCircularProgress!
    var btnSound: AVAudioPlayer!
    var endSound: AVAudioPlayer!
    var zazen: Double = 60
    let defaults = UserDefaults.standard
    let mode = "mode"
    let bell = "bell"
    let durationSlide = "durationSlide"
    var timerRunning: Bool { return self.countdownTimer != nil }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var gearButton: UIButton!
    @IBOutlet weak var timerHostView: UIView!
    
   
    var mute = false
    weak var countdownTimer: Timer!
    var countEndAt: Date!
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.progress != nil { return }
        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
        
        
        if let durationSlide = defaults.value(forKey: durationSlide) {
            slider.value = durationSlide as! Float
            durationSliderValueChanged(slider)
        }
        
        
        countDownLabel.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = true
        progress = KDCircularProgress(frame: self.timerHostView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.3
        progress.trackThickness = 0.31
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .constant
        progress.glowAmount = 0.3
        progress.trackColor = UIColor.darkGray
        progress.set(colors: UIColor.black)
        self.timerHostView.addSubview(progress)
        progress.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
        var path = Bundle.main.path(forResource: "ThreeBells", ofType: "aiff")
        if UIDevice().userInterfaceIdiom == .phone {
           path = Bundle.main.path(forResource: "ThreeMediumBells", ofType: "aiff")
        }else{
            path = Bundle.main.path(forResource: "ThreeBells", ofType: "aiff")
        }
        
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        self.view.bringSubviewToFront(self.timerButton)
        
        var path2 = Bundle.main.path(forResource: "One Bell", ofType: "aiff")
        if UIDevice().userInterfaceIdiom == .phone {
            path2 = Bundle.main.path(forResource: "OneMediumBell", ofType: "aiff")
        }else{
            path2 = Bundle.main.path(forResource: "One Bell", ofType: "aiff")
        }
        
        let soundURL2 = URL(fileURLWithPath: path2!)
        
        do {
            try endSound = AVAudioPlayer(contentsOf: soundURL2)
            endSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        self.view.bringSubviewToFront(self.timerButton)
        
    }
    
    func startCountdown() {
        self.countEndAt = Date(timeIntervalSinceNow: 5)
        countDownLabel.text = "\(timeFormatted(abs(self.countEndAt!.timeIntervalSinceNow)))"
        countDownLabel.isHidden = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        if let interval = self.countEndAt?.timeIntervalSinceNow, interval > 0 {
            countDownLabel.text = "\(timeFormatted(abs(interval)))"
            countDownLabel.isHidden = false
            
        } else {
   ////REMOVED THESE BECAUSE THEY STOP THE MEDITATION TIMER WHEN THE COUNTDOWN TIMER COMPLETED/////////
            ///////////////////////////////////////////
            endCountdown()
            startAnimatedTimer()
           ///////////////////////////////////////////
        }
    }
    
    func endCountdown() {
        countdownTimer?.invalidate()
        countDownLabel.isHidden = true
        self.stopAnimatedTimer()
        self.btnSound.stop()
        self.endSound.stop()
        label.isHidden = false
        slider.isHidden = false
        sliderValue.isHidden = false
        gearButton.isHidden = false
    }
    
    func timeFormatted(_ totalSeconds: TimeInterval) -> String {
        let seconds: Int = Int(totalSeconds) % 60
        if seconds == 0 { return "" }
        return String(format: "%01d", seconds)
    }
    
    
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
            zazen = Double(Int(sender.value))
            let currentValue = Int(sender.value)
            label.text = "\(currentValue)"
        
        defaults.set(sender.value, forKey: durationSlide)
    }
    
    
    @IBAction func animateButtonTapped(_ sender: AnyObject){
        if self.timerRunning || self.progress.isAnimating() {
            self.stopAnimatedTimer()
            self.endCountdown()
            return
        }else{
    /*    if self.progress.isAnimating () || btnSound.isPlaying || countDownLabel.isHidden == false || timerRunning == true{
            self.progress.stopAnimation()
            endCountdown()
            self.btnSound.stop()
            self.endSound.stop()
            label.isHidden = false
            slider.isHidden = false
            sliderValue.isHidden = false
            gearButton.isHidden = false
            
        } else {*/
            stopAnimatedTimer()
            startCountdown()
            label.isHidden = true
            slider.isHidden = true
            sliderValue.isHidden = true
            gearButton.isHidden = true
            
           
     //   }
        }
        
    }
    
    func startAnimatedTimer() {
         if self.defaults.bool(forKey: "bell") == true {
            self.playSound()
            label.isHidden = true
            slider.isHidden = true
            sliderValue.isHidden = true
            gearButton.isHidden = true
        }
        self.progress.animate(fromAngle: 0, toAngle: 360, duration: self.zazen*60) { completed in
            if completed {
                if self.defaults.bool(forKey: "bell") == true {
                    self.playEndSound()
                    
                }
            } else {
                
            }
        }
    }
    
    func stopAnimatedTimer() {
        self.progress.stopAnimation()
        self.progress.progress = 0
        self.btnSound.stop()
        
    }

    func playSound() {
        if self.btnSound.isPlaying {
            self.btnSound.stop()
        } else {
            self.btnSound.currentTime = 0
            self.btnSound.play()
        }
    }
    
    func playEndSound() {
        self.endSound.currentTime = 0
        self.endSound.play()
    }
 

}
